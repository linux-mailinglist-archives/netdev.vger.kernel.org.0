Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6706EDAE3
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 06:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbjDYEPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 00:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjDYEP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 00:15:28 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508FC7D8C
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 21:15:26 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1a920d484bdso43376455ad.1
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 21:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682396126; x=1684988126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8xA5GFJUI1pB9OXuyVpA9/xSaHhyhi+2/fpwahpKbPo=;
        b=UcizPdRO4ESrsdyOAkxK1Zt6Yrstc4/KbzKbbpwtYs4rie8vF+mQASzSzQbXbgseuJ
         5yIBwKk/1hy+KpABi5hw7/jJBRndoJQ00RVPMb3r653M9oKg3DasbFvsX4y9b/VhtlQb
         d1INWcelO18gsnKLHzQzYwqWb7xHzRMMMo/EpUUP0x+zuq+M7vE65bu9PGiS6Sn1Xv30
         zbuGpAA5XGxpxoa+uiIwgKRlO+QbnkpuxR8QkOrahM84fDwzssWt+7F0DeduSrsvgUrQ
         AGCE4zEsAI3yy4StWenqzJ0OiGO89/0Z8jXBQLB+LiJBF8VJwVUxdekuUhwVI8DvpHgU
         h6tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682396126; x=1684988126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8xA5GFJUI1pB9OXuyVpA9/xSaHhyhi+2/fpwahpKbPo=;
        b=JITM/iQ3xMQUI88SKO3s1+QdVGE+fFQ+u8CoJuT5BHQn03TJGdK0DfraesVph/dgsx
         HG6dplBKmOVf60vY5s4B/HRxgFGHhmYTj8qg2CsV4wWb9/rdwY1BEpKrWa6qpR8AjHOg
         ge3v8Ret6DI5YNuEuca9oHPECszadoGOw22GwTHVoLj3o6SdvIBl/To1RccwbCkQOL8y
         H1gmaqVrPycIqaHyb9/xmKN54bUNojj1Uz7Zis6ViOuwVW9Sd5dMz1fTkMYUDuAbNPoF
         dBkHmFzQ5eecyO3gJqwQ6VR1C7BPV4WboiCb6KdElVW8Bcas32XRhJ5YQYs6Z+Fc2SEC
         KxSA==
X-Gm-Message-State: AAQBX9cjL9yRkejslBSndqL8JELmjsDoYDHnoq2QW+UZDiS06JU94g/T
        ba5TOq6s95fX5heBtSPJxJ/Z3Rd7FaYP7Uy4kRY=
X-Google-Smtp-Source: AKy350Zsxus65+SA18EWygR/2hBFX4/c2yvxt8oThRVgfLliFxSzMSb5uCnNXFBs6tvNLEV6HmPV2vslMRysiPQwUc0=
X-Received: by 2002:a17:902:c74a:b0:1a5:a1b:bbd8 with SMTP id
 q10-20020a170902c74a00b001a50a1bbbd8mr13736341plq.45.1682396125472; Mon, 24
 Apr 2023 21:15:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230423032849.285441-1-glipus@gmail.com> <ZEZMdKBBxg5cQ/Mg@Laptop-X1>
In-Reply-To: <ZEZMdKBBxg5cQ/Mg@Laptop-X1>
From:   Max Georgiev <glipus@gmail.com>
Date:   Mon, 24 Apr 2023 22:15:14 -0600
Message-ID: <CAP5jrPGCU4jce6ALDWZ5vhyk0Jicy2sQ_=CzRTG88T03FE4rwQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 4/5] Add ndo_hwtstamp_get/set support to bond driver
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 3:31=E2=80=AFAM Hangbin Liu <liuhangbin@gmail.com> =
wrote:
>
> On Sat, Apr 22, 2023 at 09:28:49PM -0600, Maxim Georgiev wrote:
> > This patch changes bonding net driver to use the newly
> > introduced ndo_hwtstamp_get/set API to pass hw timestamp
> > requests to underlying NIC drivers in case if these drivers
> > implement ndo_hwtstamp_get/set functions. Otherwise VLAN subsystem
>
> nit, Otherwise Bonding subsystem...
>
> others look good to me.
>
> Thanks
> Hangbin

Hangbin, thank you for catching it!
