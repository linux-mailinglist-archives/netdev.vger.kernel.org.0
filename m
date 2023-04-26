Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC0E6EF5F9
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 16:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241091AbjDZOEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 10:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbjDZOEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 10:04:34 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5BE6591;
        Wed, 26 Apr 2023 07:04:33 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-63f167e4be1so1597328b3a.1;
        Wed, 26 Apr 2023 07:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682517873; x=1685109873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hKeiY5CthaymqqIoyhwRhsa9F2nLakeekPNwgaCPpu4=;
        b=VzbiAL0KQ6HI70qiqJgmt4uzcaH/FeNPeUpLyF5pr1/WBMOrSXM1voso8t6g/SjVVL
         NInFt5eTJmIxcM9Qoi/Kyo/BTXSroddxvoM+7NEnt2U77dORezdZU9R7y4SOJOn6iGco
         Q9Ug91HyycpsXBDWbPCxf4uzaZpwgloED6ayLtOig9PjWCDjyxW84l3+oxZO9jKFQRQJ
         buwdumZLhAZOUdoDZog1MQCxdPBguzb4Ks4FO0AHYJyY0sj+mROEnr7IbHY8peVqGpyc
         Z7Hmm83KZmh1EYmcu7Lnu/8q41nOHSIdLbGnj7dPehSSgiuRba4GlyEOP7NgvFN00vsk
         2yeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682517873; x=1685109873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hKeiY5CthaymqqIoyhwRhsa9F2nLakeekPNwgaCPpu4=;
        b=bacUGX8/8wbab0pU7Ph2vU4bShv7NCMuVc6lxnNZK71ny0bt7QmFRF1IRexqWm1kTT
         pgx2RHf4QcQqWQLW5Zgs2udyFU9ERqPOWERK9vQy/Kh0TorCDkEdkhtWKtmYyjfo5EJv
         n4+KtW3ciwKwNssnqxHH8zK5g12iM2sd7h8G+EGCeDmn8gkLNl7cPy0a9o3O6a0bJyU5
         mimn/3cRAL5GPmETeTbBQlW+gi71O7UbJgYm5ifSUWrbj3z4VOFGQlogO3ae/MWyvPYq
         MgNWOZYFc9+t2i/L06gmtBmsQjfeHfn1rIdLIwXu4njjLyEY3r20IQKSXknT3DJMNq3J
         YZOQ==
X-Gm-Message-State: AAQBX9fhJmzR2wyrFG61ZKU5nrFlMLQuIQFHASp/LUp64VxRAdxBUzli
        6RjCoY6alnziB1BrNFznYNunW2TPLag=
X-Google-Smtp-Source: AKy350ahjusk3gSvTYHaUKOAZLHcDmgoanbU5xf1F/vXEpOKpObKtTUZHhAT/jpYjvTadQ3gG7lqVg==
X-Received: by 2002:a05:6a20:394f:b0:f1:1ab5:5076 with SMTP id r15-20020a056a20394f00b000f11ab55076mr8078485pzg.2.1682517872771;
        Wed, 26 Apr 2023 07:04:32 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p2-20020a056a000a0200b00638c9a2ba5csm11390985pfh.62.2023.04.26.07.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 07:04:32 -0700 (PDT)
Date:   Wed, 26 Apr 2023 07:04:30 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Stern, Avraham" <avraham.stern@intel.com>
Cc:     "Greenman, Gregory" <gregory.greenman@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: pull-request: wireless-next-2023-03-30
Message-ID: <ZEkvbvIZiUnbK45N@hoboy.vegasvil.org>
References: <20230331000648.543f2a54@kernel.org>
 <ZCtXGpqnCUL58Xzu@localhost>
 <ZDd4Hg6bEv22Pxi9@hoboy.vegasvil.org>
 <ccc046c7e7db68915447c05726dd90654a7a8ffc.camel@intel.com>
 <ZEC08ivL3ngWFQBH@hoboy.vegasvil.org>
 <SN7PR11MB6996329FFC32ECCBE4509531FF669@SN7PR11MB6996.namprd11.prod.outlook.com>
 <ZEb81aNUlmpKsJ6C@hoboy.vegasvil.org>
 <ZEctFm4ZreZ5ToP9@hoboy.vegasvil.org>
 <SN7PR11MB6996324EBF976C507D382C3AFF649@SN7PR11MB6996.namprd11.prod.outlook.com>
 <ZEiP3LDTQ86c4HaN@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEiP3LDTQ86c4HaN@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 07:43:40PM -0700, Richard Cochran wrote:
> Your design might touch upon a number of points...

I forgot the most important point, IMO:

How will you handle time distribution across a wireless network?

Consider the following simple case.

GPS Radio ------> Station-A ~~~~~~ AP ~~~~~~ Station-B
           1PPS              WiFi      WiFi

Here Station-A should become the PTP server, and Station-B should
become a PTP client.  In 1588, this is accomplished by forming a
spanning tree over the wired network, based on time quality fields
advertised.

AFAICT, the standards provide almost no hint how this is supposed to
work over WiFi.  I'd like to know your plans for solving this aspect.
Just exposing FTM to user space doesn't help all.

It gets even better.

Replace that "AP" with "mesh network" and image Station-B moves around...
What happens next?

Thanks,
Richard







