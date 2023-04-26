Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9A46EED06
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 06:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239386AbjDZEns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 00:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239327AbjDZEnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 00:43:47 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF39133
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 21:43:46 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1a68d61579bso51010725ad.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 21:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682484226; x=1685076226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3v6ztOpcd63Ih5m5M3r/JND6OTPH7gSvq7/e6FRHMQ=;
        b=rgvsNA4Kg2xERL87RwUV5POl9z8YyQYkS+xJHv21Zg6eGHXJlg2j+rnz3lBkqcs9zs
         sCTXC+L1YEjZXgcemh6swajHrNMTQfvkGhdOtuVjj22hV4vhnFfKbsqqErykRY227Nd8
         8xZCWY3LM13mhL8zb1bq1c7eQPAMwTCGtfoPrIO8n1+5PFMe+47OAgQOlSdLdoi2iiPI
         da5p+bIRQd2LfPKqplm3IAXU6hZK4BrnM9gXjyT/Cq8cmIkWb57dyhipA3ZnwLtAsXum
         MOmosi2pYOOgNzEm/V6i8DAovIsYuj6+S/g2NPg0TeLvS7OKPl7uIbl6FpYcIe3qurnb
         XIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682484226; x=1685076226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T3v6ztOpcd63Ih5m5M3r/JND6OTPH7gSvq7/e6FRHMQ=;
        b=dnqNvY/mo4jvQ6byGS95HuL4wgmda1My9WonGkET4n2NHrdbVnkb+sMofwaBwDELwl
         EXbluVrqpY/BvDD2MbX1wPebFEo3zvSFC0H8BrFRv+EYeneV15lkxUX4DG8vPMiphpx2
         1j0jEalkiuFGi4yUDQcaYAZD2b7oHhEP0LgGHNrfR8I1i/SPEwgTBZF4tZuh+2AXZ3mB
         sUcsieCIa8wWJs9ruuZ13PjZoU9zHR9JLofUpSIEUwtIMhuSXY0aaFXQKnzrcUq8e4Dj
         k/2O3Y9odlryKDUNSiDj72ZwlQSBhn/bcvc+rcoWKIp035ChirVDf1ZmImdab9caqAnN
         +x6w==
X-Gm-Message-State: AAQBX9dtArp8TtEaVipLxCe2G35wwIvshHZv3CtTWEW9riQcSnLPLkDl
        DIj7o6tgUDCiQqc4oz20B4/KP0ahIGRDjbE5/46aVe5ABmU=
X-Google-Smtp-Source: AKy350a+hv/0YcrwxrdgiDv4n+v7oMAW3xmoayhILX33MoM7/8PrabScCMk16ECLguctXOHUtVJKA13GeEurP+ZLsWI=
X-Received: by 2002:a17:902:ab07:b0:1a1:defc:30d8 with SMTP id
 ik7-20020a170902ab0700b001a1defc30d8mr20389870plb.32.1682484225691; Tue, 25
 Apr 2023 21:43:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230423032835.285406-1-glipus@gmail.com> <20230425085854.1520d220@kernel.org>
In-Reply-To: <20230425085854.1520d220@kernel.org>
From:   Max Georgiev <glipus@gmail.com>
Date:   Tue, 25 Apr 2023 22:43:34 -0600
Message-ID: <CAP5jrPEZ12UFbNC4gtah9RFxVZrbHDMCr8DQ_vBCtMY+6FWr7Q@mail.gmail.com>
Subject: Re: [RFC PATCH v4 3/5] Add ndo_hwtstamp_get/set support to
 vlan/maxvlan code path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kory.maincent@bootlin.com, netdev@vger.kernel.org,
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

On Tue, Apr 25, 2023 at 9:58=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Sat, 22 Apr 2023 21:28:35 -0600 Maxim Georgiev wrote:
> > -             if (!net_eq(dev_net(dev), &init_net))
> > -                     break;
>
> Did we agree that the net namespace check is no longer needed?
> I don't see it anywhere after the changes.

My bad, I was under the impression that you, guys, decided that this
check wasn't needed.
Let me add it back and resend the patch.
