Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37782255628
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 10:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbgH1IOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 04:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728555AbgH1IOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 04:14:17 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46A7C061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 01:14:16 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id b79so107423wmb.4
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 01:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=g7Kwv67+H7LZZde7VP4XyHAnaV1ASi6m0ZVOcAyLbiM=;
        b=Rm9fYsWQ5gqKgl2RhPmKcIhRLri92CkaZflyIXr3Rx4NmxwZ6wYpwxvjbLdvVRgxwE
         Zpt8KTrXtW8S3Fytt7WuBq4NlKc0nWOH53zQhvsijqdQCmQFcyHQUxLM2Ou9Xl6jrjvJ
         Ek5OauBe6bJ3vN5qdoswR3YTUTKE+G4FxpW1Vc4XCf0CWTJ8Y15y3sUp/YRE7cFTWBXs
         vrIxDem4eu6L6TxTZ1TXjJjp9gvpj2m6uu/xwpM1XytmWoPK0b+sWA149lhVR/Tdi+B2
         3pMBUEM4NQyN+692t39Ys0zpOyicnXdBG1fqT9vj+F0sLhzALHbglsMaAx4fV+0Nbw6w
         06dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g7Kwv67+H7LZZde7VP4XyHAnaV1ASi6m0ZVOcAyLbiM=;
        b=Q4q5V3lHJFvcJkvDuIw4oPaclxy6q8rkvwd6K4lcUA1dImyc0P6TyXT2vbVbILXOdN
         brW7WFZZuKHVuXpg1Cfxq1UKo5OxFGXrSF1nKUP4ST3fbXd5qRXDcWBo9iSnoQq50Dx7
         knVwwuhWm8ErBSUDrlXd6WwXfQIXMNsnPUvZDUlcbl4wQUxmuFYsFsLpfH110FXqlpcx
         ZNYVN6bXgF9RIUC3wVkwnGqjNi/FaoTJDClfJLQPRy/yBmdQ75GiQRmMQ4gq2rxU1jWJ
         5ToJ8uv6jMFEABX2uQ6PvsAchCjwIPw0BDISswXmN3qapfUf0wRIG3doGfgtdAdjpdbb
         eQaA==
X-Gm-Message-State: AOAM532OO669TKz4QIG+zj0pc8DfuSmHjYgk9hhl8u9w3t9RzJjU8ePy
        SCZoRuwSuEb6PhJi6qvpbsKgsoEBGtE=
X-Google-Smtp-Source: ABdhPJyEqcH1LJ63EfMOZ97jiXYKwiT3Sj/3eLh1++xyzmLRFwwoX1O6QJOXYh8y1Df2v4tK9RiFOg==
X-Received: by 2002:a1c:cc0d:: with SMTP id h13mr442429wmb.44.1598602455353;
        Fri, 28 Aug 2020 01:14:15 -0700 (PDT)
Received: from [192.168.8.147] ([37.171.241.197])
        by smtp.gmail.com with ESMTPSA id z6sm603760wrt.91.2020.08.28.01.14.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 01:14:14 -0700 (PDT)
Subject: Re: packet deadline and process scheduling
To:     "S.V.R.Anand" <anandsvr@iisc.ac.in>, netdev@vger.kernel.org
References: <20200828064511.GD7389@iisc.ac.in>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c9eb6d14-cbc3-30de-4fb7-5cf18acfbe75@gmail.com>
Date:   Fri, 28 Aug 2020 10:14:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200828064511.GD7389@iisc.ac.in>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/27/20 11:45 PM, S.V.R.Anand wrote:
> Hi,
> 
> In the control loop application I am trying to build, an incoming message from
> the network will have a deadline before which it should be delivered to the
> receiver process. This essentially calls for a way of scheduling this process
> based on the deadline information contained in the message. 
> 
> If not already available, I wish to  write code for such run-time ordering of
> processes in the earlist deadline first fashion. The assumption, however
> futuristic it may be, is that deadline information is contained as part of the
> packet header something like an inband-OAM. 
> 
> Your feedback on the above will be very helpful. 
> 
> Hope the above objective will be of general interest to netdev as well.
> 
> My apologies if this is not the appropriate mailing list for posting this kind
> of mails.  
> 
> Anand
> 

Is this described in some RFC ?

If not, I guess you might have to code this in user space.


