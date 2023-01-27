Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6057467EF2E
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 21:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbjA0UGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 15:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbjA0UFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 15:05:51 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AB988F36
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 12:04:43 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id q130so2347795iod.4
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 12:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r1i78h8zfrhhBk19TtBhhXNWZqZGTNvoG9r0RqEMGUI=;
        b=dKh5Ll2TfifKZzVwuHhAZg5hOSaUDku2oVZyDMpc0i/DEbXU18eIxCIzA3YcYus8rD
         Sl415Tb2ANU7zVQmI1EC1DBbVRjG2EBjmPt7h1EAeCnYznEPtk7b2J3CCZh5ZLmSqr5a
         9wxQAWhU+2XnCu+xq4aYakzoABr77Xe0PusBWSCfBsdaR6oOiiseP1EI3viuZklI+ZV7
         mEr8jfZI/n3DufcN0jVuW5LKCPudPPumS9vLPvS3+F1dfHt9yz/E5r9JgLQzlEMm2JMO
         Meiu9RAfsZ4pnOfQl+U/uhhmiqGjGFbNJC0SGBzxZ5DqakWR3Zgn8CoiOagsRdJ7UNcz
         zypQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r1i78h8zfrhhBk19TtBhhXNWZqZGTNvoG9r0RqEMGUI=;
        b=HQ1vhGDS/xl1we1qJQoWt6CARFihywlHj4JRpUiDHfr5IohXbOqmy24OEuycsKQGaw
         phpkvonTk7jECzRjLqu1YLq7Ng3VdNfbgsND1+C8BZQtCiiIKGzHyLpvPbr0N+sI3/AG
         Rqtsx5mPPwezjZ71oj2Yk3t4vUZ9XSUZSe9Z7PoVQpWDnwcLfzuUKKm1BBIqLKcCtL9l
         oOSrLTfJRKNY2QYCLYpmkw5ZjoPSl+wDy/I4yHAej9SuiafVNmWFdr4P208RjvUksEMy
         6ybFscbMQ3LPUp124MAHMPvUGGO/BZvFtf378bhe+t5J6wBFdE9b6/FgJ2wyh7+jlKHm
         /PDQ==
X-Gm-Message-State: AFqh2kpEbLCu3YGteAQQx8D7mtq/JOItZfVlCiGx5Gg0GubxW0Ids0o9
        gaT4UwYt6WvO76a0FsfQsTG+v7r19Hvu7zZrJUkMrg==
X-Google-Smtp-Source: AMrXdXsM4Cfg/lhIVEQ51xVujh6uJgjahwrnV3UcKhfiVm2Rk+1gYNgu3p/Em8jBOFhabiWq4oVlsDZ7LfFIcXM3ySQ=
X-Received: by 2002:a02:2949:0:b0:3a5:f9ae:71f2 with SMTP id
 p70-20020a022949000000b003a5f9ae71f2mr4637239jap.153.1674849882563; Fri, 27
 Jan 2023 12:04:42 -0800 (PST)
MIME-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
 <Y9QXWSaAxl7Is0yz@nanopsycho>
In-Reply-To: <Y9QXWSaAxl7Is0yz@nanopsycho>
From:   Jamal Hadi Salim <hadi@mojatatu.com>
Date:   Fri, 27 Jan 2023 15:04:31 -0500
Message-ID: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 1:26 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Fri, Jan 27, 2023 at 12:30:22AM CET, kuba@kernel.org wrote:
> >On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:
> >> There have been many discussions and meetings since about 2015 in regards to
> >> P4 over TC and now that the market has chosen P4 as the datapath specification
> >> lingua franca
> >
> >Which market?
> >
> >Barely anyone understands the existing TC offloads. We'd need strong,
> >and practical reasons to merge this. Speaking with my "have suffered
> >thru the TC offloads working for a vendor" hat on, not the "junior
> >maintainer" hat.
>
> You talk about offload, yet I don't see any offload code in this RFC.
> It's pure sw implementation.
>
> But speaking about offload, how exactly do you plan to offload this
> Jamal? AFAIK there is some HW-specific compiler magic needed to generate
> HW acceptable blob. How exactly do you plan to deliver it to the driver?
> If HW offload offload is the motivation for this RFC work and we cannot
> pass the TC in kernel objects to drivers, I fail to see why exactly do
> you need the SW implementation...

Our rule in TC is: _if you want to offload using TC you must have a
s/w equivalent_.
We enforced this rule multiple times (as you know).
P4TC has a sw equivalent to whatever the hardware would do. We are pushing that
first. Regardless, it has value on its own merit:
I can run P4 equivalent in s/w in a scriptable (as in no compilation
in the same spirit as u32 and pedit),
by programming the kernel datapath without changing any kernel code.

To answer your question in regards to what the interfaces "P4
speaking" hardware or drivers
are going to be programmed, there are discussions going on right now:
There is a strong
leaning towards devlink for the hardware side loading.... The idea
from the driver side is to
reuse the tc ndos.
We have biweekly meetings which are open. We do have Nvidia folks, but
would be great if
we can have you there. Let me find the link and send it to you.
Do note however, our goal is to get s/w first as per tradition of
other offloads with TC .

cheers,
jamal
