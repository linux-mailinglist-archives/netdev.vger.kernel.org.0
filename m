Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDF9261715
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731910AbgIHRYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731318AbgIHQRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:17:13 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8ABC09B047
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 07:42:11 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z25so17293347iol.10
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 07:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gsrAxoxUNH6lfuGDbSj+1z2HxiLhobFyYbwLHOHikiU=;
        b=iLFedLecNcoAGZ8L6wLZnY4qSM7sWxjQNwRUvlTn9iySZ7ecwMZUkEQUSRt/sqezr1
         UrOE+LbHexWta86Vr+feWztNuLvIyNnfPwLCX0j2lRmfB3AT8cvsnurTxfyU4aj7XiOc
         96XVHj6xvjHud9qFcgxNFY02A1WGb9uvbGO8WIHTDwa4/eLn3sSJAksmGndyD7JYvgnq
         iL+BHVlzjVKti5JioCoKe3DyRgmeys6BSCd5pdHoutkzsmPGpoxSmtpaloqKGTHXEVQ5
         wqudeIyJRcsDWTPw2blF/iWj2Yyja9USMyKq7uXPV1aE+mKmoJ/I6XbuWPco0cQ/bpdM
         FchQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gsrAxoxUNH6lfuGDbSj+1z2HxiLhobFyYbwLHOHikiU=;
        b=OeD6lndl9y1kuQNlhbMMW3HnvDcc5rhrJoXJDsNUeRx0Aw4M/1qlb4aNCeTSIsdv9w
         fLjuswwwSa84sD1ay9ennAPbZJXv0ERTmMlnKYLGbhFOIxxTMIriBA1ozTsC0hzoo+h5
         mVDtU2zkHNaWUpGur3pzOU1ojCS/6uoGGRfllNUOE2+XyldYfdn3+Dj77oxJ0Qeao5yT
         cTu8JJEqIKap0fMtFMwcJ2qOQb2MwoC0BtXUVDQbjoVrcj+tt7FovgA2KdOmhfKnWCwQ
         bvqEeka1tAtr10aGOfFlKAQe7sZuZcRmhOxH0dzAmk3N63wETJaD/bdq0l/I3H9SoEfM
         OJlw==
X-Gm-Message-State: AOAM531km0g8P6DMHTnaQwYWkJWq+5HaXHBn+WbfIaesiFRucsG0nDzH
        QTGkJmHoaj0E1eix1ntMttU=
X-Google-Smtp-Source: ABdhPJzewf6eF3/gDPHpJPXHiX+zfFEHdfK0by6kSg+G5W33nLcP5kozAIiEsnRgrQRHtIS1d5Z6dA==
X-Received: by 2002:a02:3445:: with SMTP id z5mr23721935jaz.134.1599576129568;
        Tue, 08 Sep 2020 07:42:09 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id j66sm10638643ili.71.2020.09.08.07.42.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 07:42:08 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 03/22] nexthop: Only emit a notification when
 nexthop is actually deleted
To:     Jiri Pirko <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-4-idosch@idosch.org>
 <20200908143959.GP2997@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <00d926ce-7ac9-fecd-5edc-cb30ad31828e@gmail.com>
Date:   Tue, 8 Sep 2020 08:42:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908143959.GP2997@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 8:39 AM, Jiri Pirko wrote:
> Tue, Sep 08, 2020 at 11:10:18AM CEST, idosch@idosch.org wrote:
>> From: Ido Schimmel <idosch@nvidia.com>
>>
>> Currently, the delete notification is emitted from the error path of
>> nexthop_add() and replace_nexthop(), which can be confusing to listeners
>> as they are not familiar with the nexthop.
>>
>> Instead, only emit the notification when the nexthop is actually
>> deleted. The following sub-cases are covered:
> 
> Well, in theory, this might break some very odd app that is adding a
> route and checking the errors using this notification. My opinion is to
> allow this breakage to happen, but I'm usually too benevolent :)
> 

That would be a very twisted app.

No other notifications go out on failure to add / replace and nexthops
should be consistent.

