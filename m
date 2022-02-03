Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5AE74A8D05
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353961AbiBCULw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353954AbiBCULv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:11:51 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F378C06173D
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 12:11:51 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id j38-20020a9d1926000000b0059fa6de6c71so3502413ota.10
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 12:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7el1iFQDw4bHHjq5GbbbknZQamZCeqFF7QzUeFeozJ0=;
        b=dxb0q5nkfXvISVc9sPcKq2w/gk1eSvVgCJc1YOjrTgiYh8lBGVZ8thOYRegARgW3I6
         NO7rhGSMTy+P7UIUJHIHdySpPuj9fMKknuNZUJs40YQU0Kj4m+ktNKmtu5c+DQky6ap+
         KkDM/w0J7XaC82zVm7czGssiNXvXrkvUdD4Y1dZaSj9FAl2fJ78A3ds0fPxev+qhoXFI
         8CtfiEMlvsnHuEV97IrqL8882YdNb4oDpp1lsNTQLdRUQ6t0xhwfaIR7k1mUJmwY4l8u
         n7/HD/34mSMweYM6ftG5FzUVzUBk/Hhnc3RvUz7WE74gl6a4+dKmqNZZyxbilnWmO8sM
         v5Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7el1iFQDw4bHHjq5GbbbknZQamZCeqFF7QzUeFeozJ0=;
        b=SpXT42lKvDYptOy7fflhXk2qKfD7c/Asu7Zgf6Pzo34LmII3RuNl9MfgzyNC1gTxFq
         ns1I41Awl1OwWBpgKO1gdD0T5DWUfSBjznUlrVHtKnLkJluNq5hMU0BxGJQ92OqSSXIb
         3x9yOpn4KbJakdsU7EW0pszqehdZxg7r1pJG6NXVwbXMcBAgeVQR1EwCNbJcnxVTZrxI
         lqO84YNEJOBK4Pr/Clas6WkZB2WdbK6I9pc9ALWSfXZ3A5EsNEJ8wJzdqcQ+g40XOPl0
         Fi9Mt84rKULJYgv6ZU43TOI2+B1dWnASbuSDCTmvcJZomB/46Pn7y2cWO3SEzANj/0rc
         oZGA==
X-Gm-Message-State: AOAM533rOJh7SE00sZpf2nSsiQIZdk6R5DJaNWOrObK56ZRVdAjEoUWt
        FP0SeQDdPbb75gguT9HuAhiiYQ==
X-Google-Smtp-Source: ABdhPJwr83W1t/xwMOlJe8FBsx6hO1Xt7rfdTgFMXYNKaiWJ7C3HscknLVwS6Wset6fIMEmwaHPDGQ==
X-Received: by 2002:a9d:68cb:: with SMTP id i11mr19654712oto.256.1643919110741;
        Thu, 03 Feb 2022 12:11:50 -0800 (PST)
Received: from builder.lan ([2600:1700:a0:3dc8:3697:f6ff:fe85:aac9])
        by smtp.gmail.com with ESMTPSA id a8sm11458735otj.47.2022.02.03.12.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 12:11:50 -0800 (PST)
Date:   Thu, 3 Feb 2022 14:11:48 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Alex Elder <elder@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        "Gross, Andy" <agross@kernel.org>,
        David Miller <davem@davemloft.net>,
        Matthias Kaehlcke <mka@chromium.org>,
        Evan Green <evgreen@chromium.org>, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, Alex Elder <elder@kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: dts: qcom: add IPA qcom,qmp property
Message-ID: <Yfw3BJLrRdY6sd5u@builder.lan>
References: <20220201140723.467431-1-elder@linaro.org>
 <20220202210638.07b83d41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <eb09c869-c5c6-4be8-5265-072849f1ecd0@linaro.org>
 <CAL_JsqLMit=e6vdum-xm1uxfCZcoJsTFe_S3k-QyVbvJPfNHew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqLMit=e6vdum-xm1uxfCZcoJsTFe_S3k-QyVbvJPfNHew@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 03 Feb 08:44 CST 2022, Rob Herring wrote:

> On Thu, Feb 3, 2022 at 5:27 AM Alex Elder <elder@linaro.org> wrote:
> >
> > On 2/2/22 11:06 PM, Jakub Kicinski wrote:
> > > On Tue,  1 Feb 2022 08:07:23 -0600 Alex Elder wrote:
> > >> At least three platforms require the "qcom,qmp" property to be
> > >> specified, so the IPA driver can request register retention across
> > >> power collapse.  Update DTS files accordingly.
> > >>
> > >> Signed-off-by: Alex Elder <elder@linaro.org>
> > >> ---
> > >>
> > >> Dave, Jakub, please let Bjorn take this through the Qualcomm tree.
> > >
> > > I don't know much about DT but the patch defining the property is
> > > targeting net - will it not cause validation errors? Or Bjorn knows
> > > to wait for the fixes to propagate? Or it doesn't matter? :)
> >
> > It might matter sometimes, but in this case it does not.
> >
> > If the DT property is present but never referenced by the
> > code, it doesn't matter.
> >
> > The code in this patch looks up the DT property, and its
> > behavior is affected by whether the property is there
> > or not.  If it's not there, it's treated as an error
> > that can be safely ignored.
> >
> > In the case this fix is actually needed, we'll need
> > both the code present and DT property defined.  If
> > the code is there but not the property, it's OK, but
> > the bug won't be fixed quite yet.
> 
> If there's only one possible node that qcom,qmp points to, you can
> just get the node by its compatible (of_find_compatible_node()). Then
> you don't need a DT update to make things work. Of course, this
> doesn't work too well if there are 10 possible compatibles without a
> common fallback compatible.
> 

In one of the latest platforms there's two QMP instances, so we decided
to make the reference explicit to prepare for the introduction of that.

So I intend to pick this patch through the qcom tree.

And we don't need to synchronize it with the net-changes; the two
changes can go independently and only when they are both in place will
the change take effect and the issue resolved.

Regards,
Bjorn
