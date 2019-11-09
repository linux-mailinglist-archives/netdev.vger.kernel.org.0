Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0509F5C68
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730734AbfKIAky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:40:54 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:46434 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfKIAky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 19:40:54 -0500
Received: by mail-io1-f65.google.com with SMTP id c6so8244656ioo.13
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 16:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dGQR8YFqmsOU20Oq4+2sLFI1QeH8TsFg0/KX3LtqfrA=;
        b=HB4oKvX/Sqq9rs4udnRHNPLtW4lbFPQ7eSN0XYxUZfZy2iv56gzxGpWfiA3WRSUJSn
         2JRHJtUWxG4d08eoudtQcEUdRDBdPiNLzMjW/8Il7kLHbaIsj2LUvWFvxp1pXbQoyBoq
         eFBGe5QU0Grey6NmfpCvomY71KKBU7oJzVkBo0u9g/V6rmyfcwNBTXVF55tCrjlripH3
         CjhKqaLVYSimzqaAHKbh/O2gmtbM4KNk6vl6deYlt5qiwf9lY7kbUdnuBoQY9CQJ/oCE
         GmnknYQ0fvlAl7t8oFM1pvLaujn1FupYwCm+iu33OzcXMFS1azlkiezLsAeNqYf0/lq7
         dOUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dGQR8YFqmsOU20Oq4+2sLFI1QeH8TsFg0/KX3LtqfrA=;
        b=kDiBHptIDNHwkxxaIAdai4SIVG/lYz7a/gMZ+sYQFRyIO8Nwne/SuXnJB5Se4HPoso
         cVIEW4PTrC29urr4TJZFpDAh4/smEosfy3gQQPdG9jrsRTfbs3JAUMxs2xBtgXeTztsd
         H1c2vLbB9MQlGrMf8AfRNZvBpNPYSd2MiL5WxHhYoKMnEyyiUQUT55fPwG7MjQsdrlwj
         XnhWMbP8SvQciJBwtSyDuJ7lj8D3fYWIggg6ULWd2xvXhOlBUodJclTC53x/9/wD7LUq
         7GVWH12nxyL+8YsWJTQaLbvTnf9x8NN/s8WO+XlSVWhfwlwgqWl9faML4bYlZTNihibC
         ko/w==
X-Gm-Message-State: APjAAAVE+xsUIpPzC0pKASzuX0z3cjKSeiqT3ksn1Mbv4CrJvhGYZp6Z
        xIpsXCNJPUzHzWiSubTJ5b4=
X-Google-Smtp-Source: APXvYqwdO+W8/lvK66lLrR54DDYSTAI9nWqtOo8SMOTtXRL0gXi5WknZBoaAaxGdQsbqandTmkZTDQ==
X-Received: by 2002:a5e:d806:: with SMTP id l6mr13536470iok.299.1573260051809;
        Fri, 08 Nov 2019 16:40:51 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:9c6a:665b:15c2:c3c0])
        by smtp.googlemail.com with ESMTPSA id s5sm615482iol.66.2019.11.08.16.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2019 16:40:50 -0800 (PST)
Subject: Re: [PATCH iproute2-next 0/3] devlink: improve parameter checking,
 resources and namespaces
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, jiri@resnulli.us
References: <20191105211707.10300-1-jakub.kicinski@netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <efc9b659-e6ab-a161-c05e-6249df096119@gmail.com>
Date:   Fri, 8 Nov 2019 17:40:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191105211707.10300-1-jakub.kicinski@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/19 2:17 PM, Jakub Kicinski wrote:
> Hi!
> 
> This set brings small fixes/improvements for devlink tool.
> First the netns reference by PID is fixed (code is in -next only).
> Next an extra check is added to catch bugs where new feature forgot
> to add required parameters to the error string table.
> Last but not least allow full range of resource sizes.
> 
> These changes are required to fix kernel's devlink.sh test.
> 
> Jakub Kicinski (3):
>   devlink: fix referencing namespace by PID
>   devlink: catch missing strings in dl_args_required
>   devlink: allow full range of resource sizes
> 
>  devlink/devlink.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 

Applied to iproute2-next. Thanks,
