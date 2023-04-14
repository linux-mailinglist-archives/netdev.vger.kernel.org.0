Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4ACF6E1EC6
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 10:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjDNIus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 04:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDNIur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 04:50:47 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5050511D
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 01:50:46 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id a10so1443714ljr.5
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 01:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681462244; x=1684054244;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=g+qogZnp1I22hcXYz3JRA4JybLZ4Qwc2k+voYfwxlYg=;
        b=V025k3UnMSIpnRrmq7f3byoPJhVs4C1137BSk2rWCrFGFiRiQlgFwUH9W+yEMvHlS9
         EjE/i75v08BG6grO0OkYv9cOlglIOAYiYpyYJpJTSLDpSgwkLyvo0bXC9q4XPrDzFKg7
         d6nJD9oQWzTB6cmow21oXFffgNwoC492NUoUpmK5HAZKUuv/DcZf91uXq1BdXHsqILF0
         f+3jAf5E8C57wQ4n21B38AA97MaU+WRpCo1W1BmSRWDaqfJ2A7/+xMfhns/+znKRFwUa
         rdWO6L+24Yd50bUc8nWBxRDdRQjjKXby0oFr30j2GynkQf9iyYCTQJ71x4Ws/lNnv7TW
         XjvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681462244; x=1684054244;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g+qogZnp1I22hcXYz3JRA4JybLZ4Qwc2k+voYfwxlYg=;
        b=U7ToUzjR/wBXurrak8MP6MgT8lWENXcrUa9Xvk6GPihGZqIh23ZFI8vcSDTjmdHDtF
         z4uStTWrU1aqxz7FIHKJ/w2dI8GW8Sl5MTygZQrOUcEuQ1/Rn3MDKfR+TbNpdPsrOSfQ
         jzFEEZ6YwWbCZmqmJa6M26BelI9yQNT8V4MIrHsrWACA0UMOTEa2kfQoxtnZczdNB0A7
         dqiMW0k0gZSYwX8kPv+vbvGHEkng/Z3lj9a/v8/RVZneOK3hTbeCce0xJMcGLsfMs9Tw
         Ct2AfN7O1ZArI6EVf4B0xXaSsZ7dQlfriXON0H0zZ+8hSFhkQFSgKGVwuITKtqJMNnc5
         bizQ==
X-Gm-Message-State: AAQBX9dBA/jxAr8/tJGSCDmcW2XdzuHxSuwDBgCivsTTiV5tNsAm5csi
        VRORHK0ORIJFy4iRVrNhLgDZxu/LSdOTUcWzAA4=
X-Google-Smtp-Source: AKy350Y8m82dNPz5509K1DQPOOT9tOEz6NC3ZuTyinbV7z8v/n97hv1+750JTuqCAiIWA4t6AUFlagGBsJTkBus5+Ys=
X-Received: by 2002:a2e:9811:0:b0:2a7:653d:1676 with SMTP id
 a17-20020a2e9811000000b002a7653d1676mr1698177ljj.2.1681462244140; Fri, 14 Apr
 2023 01:50:44 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mrs.chensusan@yahoo.com
Sender: daviddwoodd1@gmail.com
Received: by 2002:ab2:d43:0:b0:1b6:8560:681c with HTTP; Fri, 14 Apr 2023
 01:50:43 -0700 (PDT)
From:   Maxwell Kojo <inmaxwellkojo@gmail.com>
Date:   Fri, 14 Apr 2023 08:50:43 +0000
X-Google-Sender-Auth: 8B2k2JLQ8_5oKpfGse4SbB-FYbE
Message-ID: <CAPhALxeKA0CY0_i9hQUjWDg+bG6d=E4K8HHVyN+Qa7XavMUXxQ@mail.gmail.com>
Subject: Estimado amigo,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Estimado amigo,

Soy Maxwell Kojo, trabajo en un banco en Burkina Faso. Tengo una
propuesta para usted con respecto a la transferencia de fondos. =C2=BFPuede
ayudarme a repatriar algunos fondos a su cuenta en el extranjero seg=C3=BAn
el porcentaje?

Si est=C3=A1 realmente seguro de su integridad, confianza y
confidencialidad para recibir el fondo, cont=C3=A1cteme con urgencia para
obtener m=C3=A1s detalles, comun=C3=ADquese con mi direcci=C3=B3n de correo
electr=C3=B3nico privada (inmaxwellkojo@yahoo.com).

Por favor env=C3=ADeme lo siguiente

Nombres completos
DIRECCI=C3=93N
Ocupaci=C3=B3n
L=C3=ADneas Directas de Tel=C3=A9fono M=C3=B3vil
Nacionalidad

Saludos,
Maxwell Kojo.
