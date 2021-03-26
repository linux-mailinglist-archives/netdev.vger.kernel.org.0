Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20CD34A82D
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 14:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCZNdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 09:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbhCZNdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 09:33:41 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C92BC0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:33:34 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id u10so7393564lju.7
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=i4GckMD3jxBZ1SjM7hkwcHVsj1vCO9BsCUB+cH+LhOs=;
        b=kXzzQdVIRqy9FvzUdXBBbv3rJAOhIWuMYrhZ7IXZBeMJQq5YXE7VQiIgY0iILSPfwn
         x5GW4RgOUWcGRw4M+nmh+2Hneji3XF8hhHHku+m9mb8jwM1l2x0r1NvDowD5BTyZ3E9g
         AkBBM39lcNIsYBry5zrekpLV9roz4suZ3qxV0jMS2KTVYYg93rhTF4yV4Ai7eiTflfR5
         B+F5bieJl8n5Zl1eearOsMRycrJWJ0cwNEwARiLs2T6Tf4oIdsCj36cCZOmQJyRHYEYy
         hFpAFkQy1TeniIlDWDgfLiH0SNJXqtI5IYM19Fw45JtmfDAv8eKKwd580gSA4BxaCjAO
         lP/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=i4GckMD3jxBZ1SjM7hkwcHVsj1vCO9BsCUB+cH+LhOs=;
        b=ZZnjYGzK3s4Pl/YI2P/rP0W5Fi9yf/v/b94s/IWV037WZKNKREn6mAu602ZPSeni2L
         fIPMvSA45Y1FpW8Gg6GWwqgYRNtnVAuGcO/ZcKyZ4XcemggIIuXbLTtV2NFB+HLEq919
         Sd/X5QCJwo6blaqHuz/fIp5q1gvErLfyoEMwL6/Scw895fuyw7fU2ZC8Ihsu+6Fr7kck
         AuWpmffQ5HXfbnp7F9Aljh16K2EZUj7Vr3xBY3Ehrpt6rrBTDNXiyU9bBG+W6mMsNWqh
         c2ONIMJCTvHDEA2qN822AsdafUMR7+93WEun5o3ViWoRvu032C6wGHcYyJyUQ46hWTyV
         yFhA==
X-Gm-Message-State: AOAM530eNvg668ot4qiCFyBYhyNww7g5Q9zlxU7/wW1zcC+MY6yWg2O8
        1tOcGMAnsi72cXM+CQtpo88oiQ==
X-Google-Smtp-Source: ABdhPJwA5e/nPEio+8dizSPpoa9ZiiGrO2zKbFmnVVhATcHjSfvKbfrQUR8vnhVpnF3urqHo/Q32zw==
X-Received: by 2002:a2e:9b16:: with SMTP id u22mr9595624lji.184.1616765612840;
        Fri, 26 Mar 2021 06:33:32 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w28sm870344lfk.185.2021.03.26.06.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 06:33:32 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: dsa: Allow default tag protocol to be overridden from DT
In-Reply-To: <20210326125720.fzmqqmeotzbgt4kd@skbuf>
References: <20210326105648.2492411-1-tobias@waldekranz.com> <20210326105648.2492411-3-tobias@waldekranz.com> <20210326125720.fzmqqmeotzbgt4kd@skbuf>
Date:   Fri, 26 Mar 2021 14:33:31 +0100
Message-ID: <87h7kykpjo.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 14:57, Vladimir Oltean <olteanv@gmail.com> wrote:
> Hi Tobias,
>
> On Fri, Mar 26, 2021 at 11:56:47AM +0100, Tobias Waldekranz wrote:
>>  	} else {
>> -		dst->tag_ops = dsa_tag_driver_get(tag_protocol);
>> -		if (IS_ERR(dst->tag_ops)) {
>> -			if (PTR_ERR(dst->tag_ops) == -ENOPROTOOPT)
>> -				return -EPROBE_DEFER;
>> -			dev_warn(ds->dev, "No tagger for this switch\n");
>> -			dp->master = NULL;
>> -			return PTR_ERR(dst->tag_ops);
>> -		}
>> +		dst->tag_ops = tag_ops;
>>  	}
>
> This will conflict with George's bug fix for 'net', am I right?
> https://patchwork.kernel.org/project/netdevbpf/patch/20210322202650.45776-1-george.mccollister@gmail.com/

Yes; this version also fixes George's problem I think, as we do not
assign dst->tag_ops until we know it is good, but it will not merge
cleanly.

> Would you mind resending after David merges 'net' into 'net-next'?

Sure thing. Should I then call that v2 or a resend of v1? The patches
will not be identical, so v2 I guess?

> This process usually looks like commit d489ded1a369 ("Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net"). However,
> during this kernel development cycle, I have seen no merge of 'net' into
> 'net-next' since commit 05a59d79793d ("Merge
> git://git.kernel.org:/pub/scm/linux/kernel/git/netdev/net"), but that
> comes directly from Linus Torvalds' v5.12-rc2.
>
> Nonetheless, at some point (and sooner rather than later, I think),
> David or Jakub should merge the two trees. I would prefer to do it this
> way because the merge is going to be a bit messy otherwise, and I might
> want to cherry-pick these patches to some trees and it would be nice if
> the history was linear.
>
> Thanks!
