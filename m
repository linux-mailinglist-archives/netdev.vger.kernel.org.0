Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959132C2F55
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404176AbgKXRvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404165AbgKXRvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 12:51:51 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF540C061A4D
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 09:51:50 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id h19so7533039otr.1
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 09:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dgZcAum397p2JLnSMu9Tfx6bFmJxJljXgwdxIBft2qU=;
        b=OOAeaexTNdWrtNkAmYHlsVBFA5sTlRmOiCsFvy4pL27tRynQOBBbcqmUn3veDD2lRu
         lwC1uI8VTYahxiSjJiZjhClgMUfsBfBbBkWftfy7pihRRTdR5mN7hCA2SgMzS8pi7a/7
         OjPm6zaaP2vN9Geb6kS6S3Zi2N+ksSftuK+iKFOWNvgpnE9Ie5mhgB0Z8xyWNqfNKyit
         436vILyqH/QaPh7syOXlp48jgjaa+WuY3DzwxmE9dXEbtemLjqqaP5OlUfq4j5GRtDpS
         IK119lCxbp3A5toiNMhLqDofinxMJTRFtIbrNRL5d4oipX5KnUaWN3vXZ/rRK+D7wGLX
         8kfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dgZcAum397p2JLnSMu9Tfx6bFmJxJljXgwdxIBft2qU=;
        b=lvgypATXaCjdV7gSPItL79R+yvWiojC9P/0G1qF+3ST6LVR3N6/gbhwwi/SW0Ek+Y+
         A+L/uMSWA2Exv+Zwk4ra8Ov4q77YaSmXRfjZB+VnOd1JRQ5A7bgSOhaKzevn8XqOMdu9
         bY9sldsk29GhInb0VAq2TQPeLG9wzyD+0S0OIAPasr6YtZukfZ3U4LB0QbSKu68Of3lG
         4O4MEG7FakG3ytWg5AKgRVVcsHX77JMu97OlQj682fN0E9MRDoz9yXoIozBnJ/pYhxPO
         oDzazE5nBVJkTdoNaO0oOkP3cI4N+1WJhMxqGLQp/QIVfp64TvuxSKnriunif1kGD86p
         jIXA==
X-Gm-Message-State: AOAM533ztbki5OSX0PKsN93TLlRZtiv/9v1eQDTnGnFYKyM5rpOcQ+iH
        kmdOQDw3R3YvPig7aZWU6BrLEA==
X-Google-Smtp-Source: ABdhPJx0Bi9BI557Z8UPwegAPJqDFuQ2QJg9nE12QgAZLSFJWx9gcK7pnLUE2oNRHmHHuA+dXznesA==
X-Received: by 2002:a9d:1f5:: with SMTP id e108mr4289207ote.309.1606240310256;
        Tue, 24 Nov 2020 09:51:50 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id u10sm10051960oig.54.2020.11.24.09.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 09:51:48 -0800 (PST)
Date:   Tue, 24 Nov 2020 11:51:46 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Amit Pundir <amit.pundir@linaro.org>, Rob Herring <robh@kernel.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Konrad Dybcio <konradybcio@gmail.com>,
        ath10k <ath10k@lists.infradead.org>,
        dt <devicetree@vger.kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Introduce a devicetree quirk to skip host cap
 QMI requests
Message-ID: <20201124175146.GG185852@builder.lan>
References: <1601058581-19461-1-git-send-email-amit.pundir@linaro.org>
 <20200929190817.GA968845@bogus>
 <20201029134017.GA807@yoga>
 <CAMi1Hd20UpNhZm6z5t5Kcy8eTABiAj7X_Gm66QnJspZWSio0Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMi1Hd20UpNhZm6z5t5Kcy8eTABiAj7X_Gm66QnJspZWSio0Ew@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 03 Nov 01:48 CST 2020, Amit Pundir wrote:

> Hi Rob, Bjorn, Kalle,
> 
> On Thu, 29 Oct 2020 at 19:10, Bjorn Andersson
> <bjorn.andersson@linaro.org> wrote:
> >
> > On Tue 29 Sep 14:08 CDT 2020, Rob Herring wrote:
> >
> > > On Fri, Sep 25, 2020 at 11:59:41PM +0530, Amit Pundir wrote:
> > > > There are firmware versions which do not support host capability
> > > > QMI request. We suspect either the host cap is not implemented or
> > > > there may be firmware specific issues, but apparently there seem
> > > > to be a generation of firmware that has this particular behavior.
> > > >
> > > > For example, firmware build on Xiaomi Poco F1 (sdm845) phone:
> > > > "QC_IMAGE_VERSION_STRING=WLAN.HL.2.0.c3-00257-QCAHLSWMTPLZ-1"
> > > >
> > > > If we do not skip the host cap QMI request on Poco F1, then we
> > > > get a QMI_ERR_MALFORMED_MSG_V01 error message in the
> > > > ath10k_qmi_host_cap_send_sync(). But this error message is not
> > > > fatal to the firmware nor to the ath10k driver and we can still
> > > > bring up the WiFi services successfully if we just ignore it.
> > > >
> > > > Hence introducing this DeviceTree quirk to skip host capability
> > > > QMI request for the firmware versions which do not support this
> > > > feature.
> > >
> > > So if you change the WiFi firmware, you may force a DT change too. Those
> > > are pretty independent things otherwise.
> > >
> >
> > Yes and that's not good. But I looked at somehow derive this from
> > firmware version numbers etc and it's not working out, so I'm out of
> > ideas for alternatives.
> >
> > > Why can't you just always ignore this error? If you can't deal with this
> > > entirely in the driver, then it should be part of the WiFi firmware so
> > > it's always in sync.
> > >
> >
> > Unfortunately the firmware versions I've hit this problem on has gone
> > belly up when receiving this request, that's why I asked Amit to add a
> > flag to skip it.
> 
> So what is next for this DT quirk?
> 

Rob, we still have this problem and we've not come up with any way to
determine in runtime that we need to skip this part of the
initialization.

Regards,
Bjorn

> I'm OK to go back to my previous of_machine_is_compatible()
> device specific hack, for now,
> https://patchwork.kernel.org/project/linux-wireless/patch/1600328501-8832-1-git-send-email-amit.pundir@linaro.org/
> till we have a reasonable fix in place or receive a vendor firmware
> drop which fixes this problem (which I believe is highly unlikely
> though, for this 2+ years old device).
> 
> Regards,
> Amit Pundir
> 
> >
> > That said, in the devices I've hit this I've managed to get newer
> > firmware working, which doesn't have either problem.
> >
> > Regards,
> > Bjorn
