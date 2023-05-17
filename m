Return-Path: <netdev+bounces-3397-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 588C6706DD5
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12CA11C20E66
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:17:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DAA0111BC;
	Wed, 17 May 2023 16:17:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F9F111A4
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:17:07 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75D83A9F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:17:01 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-510b6a24946so1857741a12.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684340220; x=1686932220;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=002hR/SIsjsitrv+yCcTeeJ+tjVHz/NYFjhWP11n2vw=;
        b=qe8JF0BBhZeHQKZs8t2KqXm9XO+2/ZjcrjLijkUfEuNHN9vA6b/7l+POjmo3Wu5CCG
         FnbJ5enVccLbCzqHvcHWZqMSewrwFQsp7YMHr/xY7oIom9gtlqPg8DwfS/n3jIMfJ0N0
         VJ6TH94vA7WgWhrnP9pvMwqBbyEOxFLPvEjZui/fL5voQdFSICqIF/mdPQFgOAclOG2T
         diNnWkXWzcULBGd6r8h8yQUrZqee/OqXnLeAFUXEFniL10Z7O6/iJHY1MmHvRfUnKd1q
         1zBwUDYKAcEQjxgRcVDut5QtUoJr40nu7mo42dXlQV60b+OiNVgBrnUW+eOD3rxI/Iip
         BSFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684340220; x=1686932220;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=002hR/SIsjsitrv+yCcTeeJ+tjVHz/NYFjhWP11n2vw=;
        b=YrYyp1fBobT9LdOtMLBjiqj/UYTcTwmKlZ1DrF6J/Zmgsu74ttP06BmKw0TVijmz6+
         4KxG/Vq+c/GdyhNbyC3nxZYYwwI2u0aIBYthsAed2oNqXomBa1GU+oiepuiVkOkmf8PL
         Sed4TtgoG6QxaCQMpNoJkkCWI18WEuTL/NyFVmcM7QNCIJnCNyNfXTx9wp0tWVDsc3rX
         T06JzPZA44JJSiqvJV+GtZsrC7Pc21ayygE82IpEKix1uO8j+CA1o30H9hArgglyDSud
         os13rhXUGzybz5fvacype57P8+NBSEgXwt495zAL9/zoOjL7XOumAtMuTOtmXXbRaSC+
         mwZg==
X-Gm-Message-State: AC+VfDxPHb1FUNKMV/WWh0e1FPmf2REB0hFG/axBje6in5k9Tm4SsjbR
	ph+UNiD1/UTfV1INP06fQgQ=
X-Google-Smtp-Source: ACHHUZ59iQhb5jhNpg6witg1xOLepTDm36Q6Ffxh/H8wvyRluJRh/Vb8mMSEtUWGIMtFOVm59C2f8A==
X-Received: by 2002:a17:907:6088:b0:949:cb6a:b6f7 with SMTP id ht8-20020a170907608800b00949cb6ab6f7mr40594827ejc.56.1684340219952;
        Wed, 17 May 2023 09:16:59 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id ib8-20020a1709072c6800b0094f67ea6598sm12475620ejc.193.2023.05.17.09.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 09:16:59 -0700 (PDT)
Date: Wed, 17 May 2023 19:16:57 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Frank Wunderlich <frank-w@public-files.de>,
	Felix Fietkau <nbd@nbd.name>, netdev <netdev@vger.kernel.org>,
	erkin.bozoglu@xeront.com, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	John Crispin <john@phrozen.org>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>
Subject: Re: Choose a default DSA CPU port
Message-ID: <20230517161657.a6ej5z53qicqe5aj@skbuf>
References: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70>
 <20230224210852.np3kduoqhrbzuqg3@skbuf>
 <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06>
 <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com>
 <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com>
 <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15>
 <20230228115846.4r2wuyhsccmrpdfh@skbuf>
 <91c90cc5-7971-8a95-fe64-b6e5f53a8246@arinc9.com>
 <20230517161028.6xmt4dgxtb4optm6@skbuf>
 <e5f02399-5697-52f8-9388-00fa679bb058@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e5f02399-5697-52f8-9388-00fa679bb058@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 07:14:01PM +0300, Arınç ÜNAL wrote:
> On 17.05.2023 19:10, Vladimir Oltean wrote:
> > On Tue, May 16, 2023 at 10:29:27PM +0300, Arınç ÜNAL wrote:
> > > For MT7530, the port to trap the frames to is fixed since CPU_PORT is only
> > > of 3 bits so only one CPU port can be defined. This means that, in case of
> > > multiple ports used as CPU ports, any frames set for trapping to CPU port
> > > will be trapped to the numerically greatest CPU port.
> > 
> > *that is up
> 
> Yes, the DSA conduit interface of the CPU port must be up. Otherwise, these
> frames won't appear anywhere. I should mention this on my patch, thanks.

Well, mentioning it in the patch or in a comment is likely not going to
be enough. You likely have to implement ds->ops->master_state_change()
and update the MT7530_MFC register to a value that is always valid when
the conduit interfaces come and go.

