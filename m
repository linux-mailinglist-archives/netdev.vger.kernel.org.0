Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3588865FD38
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 09:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjAFI6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 03:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbjAFI5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 03:57:54 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B7BA44A
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 00:56:40 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id c8-20020a17090a4d0800b00225c3614161so4577048pjg.5
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 00:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ScW/xF95KcpV2S7pIQlo9k7Cs6sKsKMu6Wh/2HUT2Zg=;
        b=BSCDfDwSnUpjqqV0/0i0lTG3jgHuWjTqY8+2sStWMpLnCQDrHf4GhAjCDA/Ag9UsnJ
         ebgO4Sa8F5VxThorlTidKBLKnkObjeM5pN9o0n+LStPTg4qlTIrzOsl3GHaOYDruGrfJ
         xq7uJVO2iIB+4W5TNrDweHoKTHCihV2oGe8vdgF30zE1i7mpPPAJdRLhQ86lBZDathsm
         uX1TeraEOFp249HJn1T5X0k5dO6vD7HDK2fu9lKR8fw1iFQIOTWSkqoEJZMUi5TMcwCO
         gWpGvQ4hb9HuqMA9NpTUYE+xEyemgKoTY0nJdTKlpjU267miV50yKw20WBf1uQ//r7In
         WKbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ScW/xF95KcpV2S7pIQlo9k7Cs6sKsKMu6Wh/2HUT2Zg=;
        b=Sxvxn77A63I+wukRO2raj9WvYQNIRSgqaexcRVtbsINzxYg/b50ofk0mlkyYDJplHB
         n1A87lHnFm5QXRhrhxVdUXk3bdml44313lhHljFDBlyfSsg+8OSzxyk6+4pIFGFxCr1D
         Xr+tdu5qsK/nZmgJARPtUlhfWkynGraGmIxlpXw8wvKMPgUip9n+mHl46+f4Fy5WIT9l
         ghb6FovKwpeUd6kVxgA2+UwoRmuHgPl4AD0ObLeJDsMf+f7k/pj/Mo7aCahUSAQ+vSgr
         FE3b3Ze0moL3DMs08gg9WJlVM1b4RmPaCFlAyBZ875F6+yW0KE7vv29RohOrrPpclmp3
         Dq7w==
X-Gm-Message-State: AFqh2kqiYN0lth9fj/hgUzHSDXFcJbwzjNadLf7zke6k4MwuFqVdOb5g
        4i+BbbFlNKCK/lXetrVBeiHY3g==
X-Google-Smtp-Source: AMrXdXtQoTp2PDCI2h3XK1FQIRUN7sBJbgHTmThmrvGNAwFCNQBvwTvSCrTrxdpWHwEMioe/KWn1Fg==
X-Received: by 2002:a05:6a21:1507:b0:9d:efbe:529a with SMTP id nq7-20020a056a21150700b0009defbe529amr64211722pzb.10.1672995399743;
        Fri, 06 Jan 2023 00:56:39 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id d13-20020a170902e14d00b00192a1dfa711sm365866pla.258.2023.01.06.00.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 00:56:39 -0800 (PST)
Date:   Fri, 6 Jan 2023 09:56:36 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 13/14] devlink: add by-instance dump infra
Message-ID: <Y7fiRHoucfua+Erz@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-14-kuba@kernel.org>
 <Y7WuWd2jfifQ3E8A@nanopsycho>
 <20230104194604.545646c5@kernel.org>
 <Y7aSPuRPQxxQKQGN@nanopsycho>
 <20230105102437.0d2bf14e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105102437.0d2bf14e@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 07:24:37PM CET, kuba@kernel.org wrote:
>On Thu, 5 Jan 2023 10:02:54 +0100 Jiri Pirko wrote:
>> Thu, Jan 05, 2023 at 04:46:04AM CET, kuba@kernel.org wrote:
>> >> What is "gen"? Generic netlink?  
>> >
>> >Generic devlink command. In other words the implementation 
>> >is straightforward enough to factor out the common parts.  
>> 
>> Could it be "genl" then?
>
>Why? What other kind of command is there?
>The distinction is weird vs generic, not genl vs IDK-what.

Compare outputs of:
git grep _gen_ net/
git grep _genl_ net/

My point is to see consistent naming scheme. I know you don't care about
that much, but I believe it helps readability and code understanding.
What is the downside? I'm not really sure why you are against it.

>
>> >> Do you plan to have more callbacks here? If no, wouldn't it be better
>> >> to just have typedef and assign the pointer to the dump_one in
>> >> devl_gen_cmds array?  
>> >
>> >If I find the time - yes, more refactoring is possible.  
>> 
>> Could you elaborate a bit more about that?
>
>If I recall I was thinking about adding a "fill" op and policy related
>info to the structure. The details would fall into place during coding..
>
>> >You mean it doesn't have nl, cmd, dump_one in the name?
>> >Could you *please* at least say what you want the names to be if you're
>> >sending all those subjective nit picks? :/  
>> 
>> Well, I provided a suggested name, not sure why that was not clear.
>> The point was s/dump/dumpit/ to match the op name.
>
>Oh, just the "it" at the end? Sorry, I don't see the point.

The point is simple. Ops is a struct of callback by name X. If someone
implements this ops struct, it is nice to assign the callbacks functions
of name y_X so it is obvious from the first sight, what the function
is related to.

I'm not sure what's wrong about having this sort of consistency. I
believe that you as a maintainer should rather enforce it than to be
against it. Am I missing something?
