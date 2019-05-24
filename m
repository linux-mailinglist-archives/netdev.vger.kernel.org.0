Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4505929CA7
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390998AbfEXRDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:03:34 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45365 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390532AbfEXRDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:03:34 -0400
Received: by mail-pl1-f194.google.com with SMTP id a5so4397784pls.12
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 10:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=X5aEYrblRDKr+Sw1HsJ1xNbxvDNafrRP9fkohmStytY=;
        b=ZAiXQfQ0qiWMbKxjrLmu2aRtiHPyJkmuoT7LoX51b6vU2cX76UHyAXPbg78AdSPrqs
         OwwaOsC/bub3+TrD0rFzbUwrv+EnZu1DfKzXBvTT/bJDeNpfqeHT9rX+uM2UGESv2be5
         Znl/74Z9Bfo9ThEH+7pTjuKjxfdMKbWCAUfdiQKu9Kd1W1+JfWZVCN7Xh0ilD9+Lvg/S
         FgFybQ3s4u1fNlpdoNaGI7Zjad5c5/lzsp8cz4c/jPwwn7WRBIIKHKTZ/IQQq1wGP+zc
         UmNVxM1PXJx3Bw3X1SJN8gMMPAnSpsQDN7jmPYjJg1XUl8RPPIcq6U7utiFe55Fk428+
         wW+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=X5aEYrblRDKr+Sw1HsJ1xNbxvDNafrRP9fkohmStytY=;
        b=Q62hQnLAMQy5/BerPkLlXAmzGTDBzFCfUp4i8fAmfq2Kj+Mx6811byEHQBk12jTqHz
         Z69YqP1VC5PrR3bwji8907gen6L3ZQl3Giil3W/bqrVKWpQ3NMJYB5P+KjTPCojmSspv
         9axzD6mbCfKOFc8qWHmBpetOTOcH9m7Q7F0rEd/nd5gPiTLuacQnMZR8mJxnn28eHMvq
         X1i69WT8y6FTATruKpb1P+jN/ri/Y4w71Jcllda2Rh0RcIqfustK6MN4S5pvAtrWq2dx
         MmpwXfa+Prr7HWYziHMA1GBRMzHvWkS0UlvxBfoOFhTcarYaRPW26tgAT3QWXADJ4RBM
         I5Qw==
X-Gm-Message-State: APjAAAWZA763yjP1S9aGqQdeJv6iE9GbBgjPLUoqtZhJrOT2+xJiuUWb
        Fx89e9DUb1EO3JEMYp47mWZDhg==
X-Google-Smtp-Source: APXvYqw5mPiByJvTO72LbbO3csom1nW85AD8dzj3mJdxgSWjpMla4quJddxymgcqz/GPSo0waeWbRw==
X-Received: by 2002:a17:902:9698:: with SMTP id n24mr23379019plp.118.1558717413077;
        Fri, 24 May 2019 10:03:33 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 8sm3209338pfj.93.2019.05.24.10.03.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 24 May 2019 10:03:32 -0700 (PDT)
Date:   Fri, 24 May 2019 10:03:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Andy Gospodarek" <andy@greyhouse.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action
 statistics
Message-ID: <20190524100329.4e1f0ce4@cakuba.netronome.com>
In-Reply-To: <1506061d-6ced-4ca2-43fa-09dad30dc7e6@solarflare.com>
References: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
        <20190522152001.436bed61@cakuba.netronome.com>
        <fa8a9bde-51c1-0418-5f1b-5af28c4a67c1@mojatatu.com>
        <20190523091154.73ec6ccd@cakuba.netronome.com>
        <1718a74b-3684-0160-466f-04495be5f0ca@solarflare.com>
        <20190523102513.363c2557@cakuba.netronome.com>
        <bf4c9a41-ea81-4d87-2731-372e93f8d53d@solarflare.com>
        <1506061d-6ced-4ca2-43fa-09dad30dc7e6@solarflare.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 14:57:24 +0100, Edward Cree wrote:
> On 24/05/2019 14:09, Edward Cree wrote:
> > I'll put together an RFC patch, anyway =20
> Argh, there's a problem: an action doesn't have a (directly) associated
> =C2=A0block, and all the TC offload machinery nowadays is built around bl=
ocks.
> Since this action might have been used in _any_ block (and afaik there's
> =C2=A0no way, from the action, to find which) we'd have to make callbacks=
 on
> =C2=A0_every_ block in the system, which sounds like it'd perform even wo=
rse
> =C2=A0than the rule-dumping approach.
> Any ideas?

Simplest would be to keep a list of offloaders per action, but maybe
something more clever would appear as one rummages through the code.

We're happy to help out with the driver side if you get stuck on that,
BTW.
