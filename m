Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3295E6EF4C4
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 14:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240690AbjDZMyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 08:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240293AbjDZMyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 08:54:35 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7244AE3
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 05:54:33 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-959a3e2dd27so706289366b.3
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 05:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tarent.de; s=google; t=1682513672; x=1685105672;
        h=content-transfer-encoding:mime-version:content-language:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L8UCBwowXE+zXZBN/Xshkn6tHh+RnKtAaGTTD8Czx4o=;
        b=rRPvkjwtQDKtL+dNMPtjOFBmNjouBsSz7My3PGv6biQSdMjMDZc3qfLuP61bpCm3VM
         fcAb13/o3Cp3QG0ZAjCwrXHAE+yCbAaad7j6slVXSTSsym7tASn+Ou7DlcTDPUAgLh+C
         rnI8K48MwoGteqhifNISTXhFBPhZPZOrTMPic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682513672; x=1685105672;
        h=content-transfer-encoding:mime-version:content-language:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L8UCBwowXE+zXZBN/Xshkn6tHh+RnKtAaGTTD8Czx4o=;
        b=TyQLzVkLH5048edGSj6A9ePIdzKK0+lQ7MrJKFvZLKoRKICzm9vKckKaj8XsC4bcKL
         5HZVkH+JcGvXIfDaHMH5Q8UE7FSVM9FxQ5WO1OrrFdALXNFdh6tvS2x+Cfl75b7VjOm6
         YQPoiRl0HWp4di8Cy6Jiw5TnGlkXOH27KTNEDhIpSqlV2pKhxRKxifcQxDPv4ZRCmN7o
         pxEysG6oOhYF2WgUIMD9pv/+p/kNig1Lx89eibCXagMXZHN+gTe2I9oZCbNwVSXSja1k
         a2sjzZYgqxdgksmIlxAhcgs5lwPHMztG8Og3S1XtTi2Jjx2Q+dn56dHvlkqoxVITM+Re
         Bksg==
X-Gm-Message-State: AAQBX9cXeHkQdDW6XVhPs1RzNhQrWL1tNOqwpe62Ibif6BowczzitF7S
        PyRujQ6Xy8jWjmpyj2xxTc7xqewwWr9bHYq9p0DC2//BiLvpYa9bqEBuWrKqlLO731g/mb3sEil
        W63tYYenHQWiK+MsVYHQaILqXLhUbjjq9j3eHDb/fsaX4HxHGNcg2HMer2RMPQgKcI2nxgdWFjx
        U5
X-Google-Smtp-Source: AKy350Y7FNPCg+2TsDNXLfytBsP25fr0/Vds7mfkaYxmMmQsYeXLgijBiadYbQPZhfJkJh3bEg+VPQ==
X-Received: by 2002:a17:906:5e12:b0:94f:3980:bf91 with SMTP id n18-20020a1709065e1200b0094f3980bf91mr15725771eju.19.1682513671804;
        Wed, 26 Apr 2023 05:54:31 -0700 (PDT)
Received: from [2001:4dd4:f23a:0:21f:3bff:fe0d:cbb1] (2001-4dd4-f23a-0-21f-3bff-fe0d-cbb1.ipv6dyn.netcologne.de. [2001:4dd4:f23a:0:21f:3bff:fe0d:cbb1])
        by smtp.gmail.com with ESMTPSA id lw26-20020a170906bcda00b0094f185d82dcsm8144420ejb.21.2023.04.26.05.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 05:54:31 -0700 (PDT)
Date:   Wed, 26 Apr 2023 14:54:30 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     netdev@vger.kernel.org
cc:     Haye.Haehne@telekom.de
Subject: knob to disable locally-originating qdisc optimisation?
Message-ID: <8a8c3e3b-b866-d723-552-c27bb33788f3@tarent.de>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

when traffic (e.g. iperf) is originating locally (as opposed to
forward traffic), the Linux kernel seems to apply some optimisations
probably to reduce overall bufferbloat: when the qdisc is =E2=80=9Cfull=E2=
=80=9D or
(and especially) when its dequeue often returns NULL (because packets
are delayed), the sender traffic rate is reduced by as much as =E2=85=93 wi=
th
40=C2=A0ms extra latency (30 =E2=86=92 20 Mbit/s).

This is probably good in general but not so good for L4S where we
actually want the packets to queue up in the qdisc so they get ECN
marking appropriately (I guess there probably are some socket ioctls
or something with which the sending application could detect this
state; if so, we=E2=80=99d be interested in knowing about them as well).

This is especially bad in a testbed for writing L4S-aware applications,
so if there=E2=80=99s a knob (sysctl or something) to disable this optimisa=
tion
please do tell (I guess probably not, but asking doesn=E2=80=99t hurt).

Thanks,
//mirabilos
--=20
Infrastrukturexperte =E2=80=A2 tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn =E2=80=A2 http://www.tarent.de/
Telephon +49 228 54881-393 =E2=80=A2 Fax: +49 228 54881-235
HRB AG Bonn 5168 =E2=80=A2 USt-ID (VAT): DE122264941
Gesch=C3=A4ftsf=C3=BChrer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Ale=
xander Steeg

                        ***************************************************=
*
/=E2=81=80\ The UTF-8 Ribbon
=E2=95=B2=C2=A0=E2=95=B1 Campaign against      Mit dem tarent-Newsletter ni=
chts mehr verpassen:
=C2=A0=E2=95=B3=C2=A0 HTML eMail! Also,     https://www.tarent.de/newslette=
r
=E2=95=B1=C2=A0=E2=95=B2 header encryption!
                        ***************************************************=
*
