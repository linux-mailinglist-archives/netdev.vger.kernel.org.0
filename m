Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769E4278C71
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgIYPWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728888AbgIYPWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 11:22:49 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB92C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 08:22:49 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id g96so2606547otb.12
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 08:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C1cpg7VtXFYuTakWVVQJcANm/dckNApDuzwf2dV+RNU=;
        b=S2g7DXnYkxEbHPEwOcXG4/BIe4JQHbTKke/+zUJYwRIDAcwYADKSupbg5I+suD/ffK
         EDkqHHBdJDnR+86nCxCpfg1qSnq5p8v9A5etGGVxtgl/5b3bb/ESM3ZXZE0G7Yx6IxGe
         wRYVLt88lNov8ynjby/K0Xl0pheGu6rVO7xdw6EmAdtcvDTna4rKeDKEn8f7H9oyeOPE
         kawhtD+OpdMgc74vTOmEwfkffx6RrEPtgQoASbtC8IeXfuN5noAJl9Pw8VU36BlXLQ3P
         0tCm1alGdgIdWKEFWySll1up2qptclXAiSHoNRRazb5vQqW9sbNNhX7xN+r2wsG7lmPf
         gYIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C1cpg7VtXFYuTakWVVQJcANm/dckNApDuzwf2dV+RNU=;
        b=WlwPjIp+YsfOqHSgQNyQnn9BgxpXwoaWRRRf/wv4X+4AvWvqcj0OhH/H87638b4o12
         bwN/uaJ0oxmFtNxqWwlRbQ2LmAiIPveo2+aB8+mupBkKc/twVOD826A33unyw1ep4w/l
         4ra7Fj/FbvD08SnFyWV0oD2ku7hDwkdE0f+5gs8IYeff+4rEuO/J1GHmX5vOdwIp8JqP
         aDKIiui0B43fHs6YseAjI3jKF+1VYYNevioJZ5edxKRZX1jbn5M9iWkmYqAgKrqa6pxw
         nn7hsQeQqn8REn5IVMK9ipwq8mTTNRhG0oLRRV2VqahM+qE7FR3lof6XamvDw7tFjTr5
         umdg==
X-Gm-Message-State: AOAM532BmBJiqQYSKfRBBwK4LFjrDOdbL8JX9JgM6oPdoGlTvC6EzLE5
        66fGMDndGHZTgOOOuSiStltDmg==
X-Google-Smtp-Source: ABdhPJzuoOf7LZ7BKNc09GOWZI6lnKFQnTCxvdwTb+gXzuaivl2XCBGEMp4Y1sqAgRVz3CSe359PDA==
X-Received: by 2002:a9d:1:: with SMTP id 1mr662613ota.81.1601047368366;
        Fri, 25 Sep 2020 08:22:48 -0700 (PDT)
Received: from yoga (99-135-181-32.lightspeed.austtx.sbcglobal.net. [99.135.181.32])
        by smtp.gmail.com with ESMTPSA id d1sm692908otb.80.2020.09.25.08.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 08:22:47 -0700 (PDT)
Date:   Fri, 25 Sep 2020 10:22:45 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Amit Pundir <amit.pundir@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Konrad Dybcio <konradybcio@gmail.com>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: qmi: Skip host capability request for Xiaomi
 Poco F1
Message-ID: <20200925152245.GD2510@yoga>
References: <1600328501-8832-1-git-send-email-amit.pundir@linaro.org>
 <20200917160513.GO1893@yoga>
 <CAMi1Hd0S+hOLL0X8=_1KGG0G7u0bt66H6=yN=LuuX+FJb8+-4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMi1Hd0S+hOLL0X8=_1KGG0G7u0bt66H6=yN=LuuX+FJb8+-4g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 21 Sep 05:38 CDT 2020, Amit Pundir wrote:

> On Thu, 17 Sep 2020 at 21:35, Bjorn Andersson
> <bjorn.andersson@linaro.org> wrote:
> >
> > On Thu 17 Sep 02:41 CDT 2020, Amit Pundir wrote:
> >
> > > Workaround to get WiFi working on Xiaomi Poco F1 (sdm845)
> > > phone. We get a non-fatal QMI_ERR_MALFORMED_MSG_V01 error
> > > message in ath10k_qmi_host_cap_send_sync(), but we can still
> > > bring up WiFi services successfully on AOSP if we ignore it.
> > >
> > > We suspect either the host cap is not implemented or there
> > > may be firmware specific issues. Firmware version is
> > > QC_IMAGE_VERSION_STRING=WLAN.HL.2.0.c3-00257-QCAHLSWMTPLZ-1
> > >
> > > qcom,snoc-host-cap-8bit-quirk didn't help. If I use this
> > > quirk, then the host capability request does get accepted,
> > > but we run into fatal "msa info req rejected" error and
> > > WiFi interface doesn't come up.
> > >
> >
> > What happens if you skip sending the host-cap message? I had one
> > firmware version for which I implemented a
> > "qcom,snoc-host-cap-skip-quirk".
> >
> > But testing showed that the link was pretty unusable - pushing any real
> > amount of data would cause it to silently stop working - and I realized
> > that I could use the linux-firmware wlanmdsp.mbn instead, which works
> > great on all my devices...
> 
> I skipped the ath10k_qmi_host_cap_send_sync block altogether
> (if that is what you meant by qcom,snoc-host-cap-skip-quirk) and
> so far did not run into any issues with youtube auto-playback loop
> (3+ hours and counting). Does that count as a valid use case?
> Otherwise let me know how could I reproduce a reasonable test
> setup?
> 

Iirc I was able to get an IP but browsing the web would be enough
traffic to stop (without any visible faults from the driver).

So your test sounds good I would like to see a host-cap-skip quirk,
rather than a conditional on the machine compatible.

> >
> > > Attempts are being made to debug the failure reasons but no
> > > luck so far. Hence this device specific workaround instead
> > > of checking for QMI_ERR_MALFORMED_MSG_V01 error message.
> > > Tried ath10k/WCN3990/hw1.0/wlanmdsp.mbn from the upstream
> > > linux-firmware project but it didn't help and neither did
> > > building board-2.bin file from stock bdwlan* files.
> > >
> >
> > "Didn't work" as in the wlanmdsp.mbn from linux-firmware failed to load
> > or some laer problem?
> 
> While using the wlanmdsp.mbn from linux-firmware, I run into
> the following crash 4 times before tqftpserv service gets killed
> eventually:
> 
> [   46.504502] qcom-q6v5-mss 4080000.remoteproc: fatal error received:
> dog_virtual_root.c:89:User-PD grace timer expired for wlan_process
> (ASID: 1)

It loaded, but doesn't seem to come up properly. We can try to debug
this further, but I think getting the quirk in will be useful - as there
seems to be a generation of firmware that has this particular behavior.

Regards,
Bjorn
