Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0248817D
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 19:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407409AbfHIRoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 13:44:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44484 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfHIRoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 13:44:14 -0400
Received: by mail-wr1-f67.google.com with SMTP id p17so98969613wrf.11
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 10:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iNEpzubpIu3EpPISc8upM7dKavfa8FGb9bw1r+crcp4=;
        b=WyFoUYDBvfSqr5m0WLqALXBsXVxYq2imfYIx+mhzJVRD/4uvi6dXzqmdGSJlg8iix0
         Um23uYmPnBBVE+YMoulD/yHlUI1VXOiNeegRBMjkj5k57na7rCE2RRFuhitjARREWQuX
         02xqgb9s6PNLXWix/B9Cfg1PTOInzlSW6tn5StxldqPWZEl4u/xbvBvQFsd7UHaab9sM
         3xXUBs2+yepK3BW9KQscHIRiy/fc5VH8jDCItOMNuUdDbbl2dEPRjNYUmnpz9wQBZenp
         AmOOzYI8Jj8A4wHu43ORz7cjCLJ8aqBlwMCKyrdOCSrZ95Pl6pdVjW05t5prpxkQO5ud
         X7bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iNEpzubpIu3EpPISc8upM7dKavfa8FGb9bw1r+crcp4=;
        b=qWHy5NqTzFJc+bm6k74Rz8VYPIQ07RDfT5TXDf5nEbJ7x+tpty5byjixzdS8IeUdxL
         z45o6q4hmySD440GPwjceQEqUi4dR9Pi3vDgMrI+vnhZ7WsozqJNWfPk7/zStt66HLXm
         gWqbOuM/TOKRMCWIn1fB6YKz0nTmJFBtsdwgJsqOl+UyOa8+K5xMlGAOcBIcFHuuE8lj
         oFzV+5scFBbe0U3BCx+Dk6YqtkhMfcuiJfjPjiNL6RaiMqoYlQdMacTnwnvEPPry8gVT
         pOZ9i6b8c2ogPozjkkqZCaqPrxZXYJTT664XPiw5CTH62aBPffoPFdzhMSdyHhE0WXuJ
         egfg==
X-Gm-Message-State: APjAAAVQ7XrZD3kZAM5joblzbI+/zarSfKbmmzmQ7Qal8RsC6ZECx3r/
        J/AAJnt8fOK5om+HNqbjvTMpfg==
X-Google-Smtp-Source: APXvYqxJqhBXAPtjWv7mk/XnzCiwiZd7oM2DDJdsh6S4CUN5ESXb/PZCdLSZieUYd4lE63+TKOGaYg==
X-Received: by 2002:adf:f68b:: with SMTP id v11mr24216006wrp.116.1565372652624;
        Fri, 09 Aug 2019 10:44:12 -0700 (PDT)
Received: from [192.168.1.2] ([194.53.186.47])
        by smtp.gmail.com with ESMTPSA id r123sm7123090wme.7.2019.08.09.10.44.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 10:44:11 -0700 (PDT)
Subject: Re: [PATCH v3] tools: bpftool: fix reading from /proc/config.gz
To:     Peter Wu <peter@lekensteyn.nl>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
References: <20190809003911.7852-1-peter@lekensteyn.nl>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <4c366f69-2571-f1f8-52aa-16175ef45283@netronome.com>
Date:   Fri, 9 Aug 2019 18:44:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809003911.7852-1-peter@lekensteyn.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-08-09 01:39 UTC+0100 ~ Peter Wu <peter@lekensteyn.nl>
> /proc/config has never existed as far as I can see, but /proc/config.gz
> is present on Arch Linux. Add support for decompressing config.gz using
> zlib which is a mandatory dependency of libelf. Replace existing stdio
> functions with gzFile operations since the latter transparently handles
> uncompressed and gzip-compressed files.
> 
> Cc: Quentin Monnet <quentin.monnet@netronome.com>
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ---
>  v3: replace popen(gunzip) by linking directly to zlib. Reword commit
>      message, remove "Fixes" line. (this patch)
>  v2: fix style (reorder vars as reverse xmas tree, rename function,
>      braces), fallback to /proc/config.gz if uname() fails.
>      https://lkml.kernel.org/r/20190806010702.3303-1-peter@lekensteyn.nl
>  v1: https://lkml.kernel.org/r/20190805001541.8096-1-peter@lekensteyn.nl
> 
> Hi,
> 
> Thanks to Jakub for observing that zlib is already used by libelf, this
> simplifies the patch tremendously as the same API can be used for both
> compressed and uncompressed files. No special case exists anymore for
> fclose/pclose.
> 
> According to configure.ac in elfutils, zlib is mandatory, so I just
> assume it to be available. For simplicity I also silently assume lines
> to be less than 4096 characters. If that is not the case, then lines
> will appear truncated, but that should not be an issue for the
> CONFIG_xyz lines that we are scanning for.
> 
> Jakub requested the handle leak fix to be posted separately against the
> bpf tree, but since the whole code is rewritten I am not sure if it is
> worth it. It is an unusual edge case: /boot/config-$(uname -r) could be
> opened, but starts with unexpected data.
> 
> Kind regards,
> Peter

This version seems good to me, thanks!

Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
