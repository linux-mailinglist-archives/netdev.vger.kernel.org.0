Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A67654897
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 23:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiLVWhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 17:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiLVWhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 17:37:33 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E26A45A;
        Thu, 22 Dec 2022 14:37:32 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id s25so3326358lji.2;
        Thu, 22 Dec 2022 14:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rc9LxVPf5XL3WKCs60iQzZS30eKkxTZdSV5r8b1Fu+U=;
        b=Gk/gDH29MZXp+shfYCLODTN2tzejooUPpstdrMMH7j71JttwVnZBf04C9cpjGp2Xmn
         EyVMtlNb+6SOWnNpXd/aLEzQsnBtWEg7Z7pX4f6ZfwM65VBhCn4mHNUjB500uKOQMgy/
         hVq3N08fw0w5GRt5GDOt+DisUi2My65tVuhSjPM35rTs25FEcYIsCDGT8PIAEvy5tKYK
         bn4/QPBqr249+S1+SJkSH9euzVCRVWwbSZkWoEY5Wg+9dkreiGT5V3MZo9Q37OsTWib/
         m0gHKF3ILTxCpQ9j4I8lEQ9cOXsyCnzMsaX6Pt2VKrrUWrTUvSOpUSibKNx17yBLQ8BB
         3M1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rc9LxVPf5XL3WKCs60iQzZS30eKkxTZdSV5r8b1Fu+U=;
        b=ekA4k3w6Vw1qeDn5+v3wkDfUTnkvH77ju2yduQl/U5BICOFB4l0jH9moVQbXZmxkJ4
         xPywZsjGiJVaNH9XyR5NMhajEePmZiSoBO8SjxR4bpXvFRF5ZfLcVQD7/XokwVaALJV7
         57Kgsk9vcZbWWQylAQzvobI/gfdCotPDybx5uA99Tc/oGK2LECUfg/I1414IUkptmA6e
         9AzL56klmoYMVgYoMK4jOgrim//iQ3dWqGdORF+kFyrjrUvW2alcQtpy0kGEYrPHrcPi
         8N9MO7VIdfHWrntPlwHxU0XfASqND/VGNXNveGRTUGf9uI4Sr4soWrjBv/EckSdDv6Ho
         8k4g==
X-Gm-Message-State: AFqh2krcRopC0sFbV/AyDD0V88JoKayNyhVMsw+71mJCFUKqaOAx4peV
        zdBtrHOu9yVCiSx+MFIKZg6rtdoWTpZ2zpcMfV2BHhTVNjU=
X-Google-Smtp-Source: AMrXdXuB6Syp5OLH8vPzz/NgvH/nLN8Fv0s2LEkxOQUKxmbZrpOWdyt/2R8FbjEe3kfvqNrz9rT0UjdhM8E+5OdXi+U=
X-Received: by 2002:a2e:a239:0:b0:279:f016:4004 with SMTP id
 i25-20020a2ea239000000b00279f0164004mr733262ljm.163.1671748650580; Thu, 22
 Dec 2022 14:37:30 -0800 (PST)
MIME-Version: 1.0
References: <20221218234801.579114-1-jmaxwell37@gmail.com> <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
 <bf56c3aa-85df-734d-f419-835a35e66e03@kernel.org> <CAGHK07BehyHXoS+27=cfZoKz4XNTcJjyB5us33sNS7P+_fudHQ@mail.gmail.com>
 <CAGHK07D2Dy4zFGHqwdyg+nsRC_iL4ArWTPk7L2ndA2PaLfOMYQ@mail.gmail.com>
 <CAGHK07DU15NhFvGuLB6WHUF0fffT3MefL3E3JWHmtWR6Wzm0bA@mail.gmail.com> <4f52f323-c8eb-bab0-ffa8-2c53c20d35ec@kernel.org>
In-Reply-To: <4f52f323-c8eb-bab0-ffa8-2c53c20d35ec@kernel.org>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Fri, 23 Dec 2022 09:36:54 +1100
Message-ID: <CAGHK07D1T76yFv8fQ9RVdJ49ieq6Z=6FumgBbf65OyvRnVJp9Q@mail.gmail.com>
Subject: Re: [net-next] ipv6: fix routing cache overflow for raw sockets
To:     David Ahern <dsahern@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 23, 2022 at 3:17 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 12/21/22 10:39 PM, Jonathan Maxwell wrote:
> > There are some mistakes in this prototype patch. Let me come up with a
> > better one. I'll submit a new patch in the new year for review. Thanks for
> > the suggestion DavidA.
>
> you are welcome. When you submit the next one, it would be helpful to
> show change in memory consumption and a comparison to IPv4 for a similar
> raw socket program.

Sure will do, I have an ipv4 version of the test program and a better patch.
Initial results are quite similar for resource usage. The ipv6 GC does a good
job at managing memory  resources with max_size threshold removed. I'll
include some comparison stats after I test this  extensively when I submit
the new patch.
