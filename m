Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6F869FC48
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 20:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbjBVTer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 14:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBVTep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 14:34:45 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5DB184
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 11:34:44 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id cq23so34608116edb.1
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 11:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=37SZQ2TizWRn8J9p8J4vhdTIXQ2tf1+QVZM1vSpkSns=;
        b=SQx1Uyenz41+vnZ2Y5ZpufQ362dxHJrOwzheDrd14Mh9mbrBhQfoA/7E89KfDTDA1/
         BcfjRibVpb84ZM6ikuzL1x/IdIjfYvnEzihh1K26zwurSkeb5oz951Yae52ppqiDb3n0
         zBmLVE0293AfzNDnEziyTNjyorTCkEv4IJ3m73CoY0fBgr6Nmt0ctrry9MRjN4NH6Y0v
         DW1mGQAgtb/HZI/qCJz0MGnUXtcW7bm7JU2kfI2GL2k8m7kpfEnBYHyk0bG+fNUMNCiq
         0WqOOCoiskPH6UM9XSDUTMH8jdTQi1gKXGrJVWtvlv0OzmVKl42izgOAiJG3O0lCDG0F
         T75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=37SZQ2TizWRn8J9p8J4vhdTIXQ2tf1+QVZM1vSpkSns=;
        b=NSCjAj+TGFtigK7V/2++TRu6VLIIVTtm5N3FJ40kqJtT+hd5F58CDWpNOo6VS4hEX8
         YfOY7cjre3n9V4UpapsUeXr76g1YX3S0uWlwUhRrjXU1OsfdyJv74O1rHKJABCHV6gtR
         ECNVd2nvXRu8jScdEEU/IE1kzag/8RvJYm6fzqMkg03yKGtIUz2Ym7HuIk4+2hT0ypDT
         R9fMqUlBK9NktrryJpcG4Rb2QQNqeIaBYsR8JwGvq3VkBkBPrsIuL6TrHUi5igeotGnC
         iq78dWsf2pVIfLVmhVouIXd5N6wygcFnOcibShCvvi4SPfvw5Gxvtw031IeGzgcAWZRf
         zJeA==
X-Gm-Message-State: AO0yUKV2E88dG0oa8NEf4tJXdRqZ8xWtNlo4huvBcXeWjfr518TZorZW
        g6VpKbfHMHwLQ5672tjaBWk=
X-Google-Smtp-Source: AK7set+2ozfkpRM5wZIcxheOcCybvvDrW/8ZT12Wmfxukv9Ep9uvL/aBvAO1fB2JkDXUH4YhADiDuw==
X-Received: by 2002:a17:906:240f:b0:8b2:b711:5e62 with SMTP id z15-20020a170906240f00b008b2b7115e62mr20047643eja.52.1677094482799;
        Wed, 22 Feb 2023 11:34:42 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id v27-20020a1709063bdb00b008d5d721f8a4sm3947088ejf.197.2023.02.22.11.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 11:34:42 -0800 (PST)
Date:   Wed, 22 Feb 2023 21:34:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: Choose a default DSA CPU port
Message-ID: <20230222193440.c2vzg7j7r32xwr5l@skbuf>
References: <5833a789-fa5a-ce40-f8e5-d91f4969a7c4@arinc9.com>
 <20230218205204.ie6lxey65pv3mgyh@skbuf>
 <a4936eb8-dfaa-e2f8-b956-75e86546fbf3@arinc9.com>
 <trinity-4025f060-3bb8-4260-99b7-e25cbdcf9c27-1676800164589@3c-app-gmx-bs35>
 <20230221002713.qdsabxy7y74jpbm4@skbuf>
 <trinity-105e0c2e-38e7-4f44-affd-0bc41d0a426b-1677086262623@3c-app-gmx-bs54>
 <20230222180623.cct2kbhyqulofzad@skbuf>
 <9c9ab755-9b5e-4e76-0e3c-119d567fc39d@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9c9ab755-9b5e-4e76-0e3c-119d567fc39d@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 09:08:03PM +0300, Arınç ÜNAL wrote:
> On 22.02.2023 21:06, Vladimir Oltean wrote:
> > On Wed, Feb 22, 2023 at 06:17:42PM +0100, Frank Wunderlich wrote:
> > > without Arincs Patch i got 940Mbit on gmac0, so something seems to affect the gmac when port5 is enabled.
> > 
> > which patch?
> 
> I believe Frank is referring to the patch series I submitted which adds
> port@5 to Bananapi BPI-R2. Without the patch, gmac0 is the default DSA
> master.
> 
> https://lore.kernel.org/linux-mediatek/20230210182505.24597-1-arinc.unal@arinc9.com/
> 
> Arınç

And with your patch + my patch, gmac0 is still the default DSA master,
but gmac1/port5 are also enabled. The claim is that switch port 6/gmac0
has lower bandwidth when switch port 5/gmac1 is enabled, than when it isn't?

Frank's testing is done on the MT7623 SoC (with the MT7530 switch),
an SoC which you have access to, since you've submitted those device
tree changes, correct? Do you confirm his result?

The posted ethtool stats are not sufficient to determine the cause of
the issue. It would be necessary to see all non-zero Ethernet counters
on both CPU port pairs:

ethtool -S eth0 | grep -v ': 0'
ethtool -S eth1 | grep -v ': 0'

to determine whether the cause of the performance degradation is packet
loss or just a lossless slowdown of some sorts. For example, the
degradation might be caused by the added flow control + uncalibrated
watermarks, not by the activation of the other GMAC.
