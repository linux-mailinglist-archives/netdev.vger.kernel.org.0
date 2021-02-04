Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A867230F3F3
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 14:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236353AbhBDNe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 08:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbhBDNef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 08:34:35 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8938BC0613D6;
        Thu,  4 Feb 2021 05:33:54 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id r38so2063165pgk.13;
        Thu, 04 Feb 2021 05:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7E2+URenrd02JuDTOl1dG1kmc1bcaQpzzQG1A2OL4Rc=;
        b=UJ5Gmfbzqg5ZrfhRXTCqNbhKkKU4qFmzNEktnxV6Q8tKkU1HRrBQLrKmq2Pm1YqNAY
         sFCI5dx9wql70Fh0KMojO+BGIfr7UofCK1EHTDUsbY9oZ2UYgcRK5C2b+0foLXlXJVlD
         cCeu4bk1yiDL2ImD91DfOa6YWKtc4Z8oduJ8c0par/xCp2vKrz/LP4userT3u5GqOIqV
         gT+ALmAMi+ygocE6g6kxpsQCnryT3CewDvOMD0izoiMTuxeN/3GjzZJemK7bazu0MTym
         ExDZcKbuI/f47BuKXOIWjOx3YlQ0sIFgrLPLexjDfatvXQbPyvf9wkoftnYPIv3OBKOb
         RmlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7E2+URenrd02JuDTOl1dG1kmc1bcaQpzzQG1A2OL4Rc=;
        b=jV/IsKDVsMvUgnBEOb/eD5GbCDxK0pX4vwg6GoYQN9wygmkXj031tawfi5lz2LHaZ7
         A1Ddc1KUY/Rs4fJ1xUwdLV51XBnZj87gN9QInlbtbVbkX7orTLuQLFskw/It2Zmw9X/3
         /Q5vLGkps1RxtHuWgkNl/5qVzjXKZ+DEiRFL6Vl1OlK/R2IfpYK1RJxDyUxyWCsFOsRS
         e2RLJqEboq0cCpsBpJz37HUxKV83P1r/K+Xkm2oqoB59tw6vuWbEmd6Ak4kXRysS0UYb
         7PNyPIpimyAN8peI/KP/B6p+LknpCHr9MEeX2IBk5pth+E23hyQGYH9vToMYLLbzaW8W
         RNHg==
X-Gm-Message-State: AOAM532Evrtm/TFKYm8QaINOANDo+sj35ChE8NnNuDNJWhEcsfFR8ikH
        pTTInOytU9elG0lQujuR6ZA=
X-Google-Smtp-Source: ABdhPJxItrjnJKzuNfHq280piki2ZNA18havliBP1HfuOEJaCKFk5XQO15wPCGRpnrJd6XzIUo10uA==
X-Received: by 2002:a65:6215:: with SMTP id d21mr8813725pgv.367.1612445634101;
        Thu, 04 Feb 2021 05:33:54 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id lw4sm4768499pjb.16.2021.02.04.05.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 05:33:53 -0800 (PST)
Date:   Thu, 4 Feb 2021 21:33:41 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        bpf@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCHv17 bpf-next 0/6] xdp: add a new helper for dev map
 multicast support
Message-ID: <20210204133341.GD2900@Leo-laptop-t470s>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210204001458.GB2900@Leo-laptop-t470s>
 <601b61a0e4868_194420834@john-XPS-13-9370.notmuch>
 <20210204031236.GC2900@Leo-laptop-t470s>
 <87zh0k85de.fsf@toke.dk>
 <20210204120922.GA9417@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204120922.GA9417@ranger.igk.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 01:09:22PM +0100, Maciej Fijalkowski wrote:
> > I think I would just resubmit with a rebase + a note in the changelog
> > that we concluded no further change was needed :)
> 
> I only asked for imperative mood in commit messages, but not sure if
> anyone cares ;)

I will try, but could not guarantee I can fix all the sentences.

Thanks
hangbin
