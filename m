Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620EFEBA6F
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbfJaXfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:35:48 -0400
Received: from mail-lf1-f47.google.com ([209.85.167.47]:45291 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfJaXfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 19:35:48 -0400
Received: by mail-lf1-f47.google.com with SMTP id v8so5944995lfa.12
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 16:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=JQzyWcJvvaSgvK8r8ua7RzXNctKNMoQLwcK5NMbSeCY=;
        b=0CjNxZ2aofCe/uVNKL3XiV8WQWiq3tj7iMhgsd0GWJ9ixBv55fwLnNphw6xzyYbQ5+
         g0sImFsSNKD6E5oFuqmQGagqpD92/CeaDp0lSH9YzN/bK1DHZC4nlnBxhQpKRSi9FmAu
         KfBya1Ad0f0IOdNX7EiOk6h5T/QW1ljUjUi8XAO0WhRg3znVicSezcHMW8BbfcAMtxAv
         hgU611eZy0WLpv5pgFIfweyagGSWM6vzsysG0egGGmUakLfnpFbYNfXDATN3ukP6qdS6
         2Y4LGUKTEH6YyCcXgSswZ1TUvipgC/eJWTn+0pX0j1QwcCcB3W8kIkQEj3kHkP70uvi6
         npdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=JQzyWcJvvaSgvK8r8ua7RzXNctKNMoQLwcK5NMbSeCY=;
        b=UN2hnhy0Tmtp2o0VLl2kx30cqy7GJGH9PzSjipmoDoLkfiquAOLc/F7IZPD70c6zpI
         kAPsV+Ty2J+4RmDQ5Fz3k6sPDHmPp2ivL1dU7LYL1cNQ0vpxbIN26YUncIG36un5Bbys
         5BaE6B3F7XpKE5xbUl+yQPJoXenIz8gU34PiyKIBmw1tdkoW0sr5U2W9Pw61wCrgqE2+
         gepA5/YlSIDWnvoFRiRjpKX8c4z0SHuSDGzksv3bk+IVKBlx6W/uop1JrnG3c3IR56ou
         jM34Y38zNgbzXJgGcwX5NdcaITKKDlYBdlvKBalOiE64ymXBdoFTqEreDr4ykpsbs8of
         U//g==
X-Gm-Message-State: APjAAAVDGKbHJVIYqcmFNF3H9WLyBKq2UFi9TeNsb/oP3o5jWnR9oGgd
        L9S05opacyM8CC1b+pVIQ2ybug==
X-Google-Smtp-Source: APXvYqwYRpuZMG1xyOrlOs/YLhgJdhb/8AEFMpxz7l5uMcNfJib7UCotewpvEYRvqh7Zc7aALfqn6g==
X-Received: by 2002:ac2:52b3:: with SMTP id r19mr5092681lfm.109.1572564945832;
        Thu, 31 Oct 2019 16:35:45 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t4sm1648573lji.40.2019.10.31.16.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 16:35:45 -0700 (PDT)
Date:   Thu, 31 Oct 2019 16:35:35 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, rong.a.chen@intel.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next] selftests: bpf: don't try to read files
 without read permission
Message-ID: <20191031163535.2737f250@cakuba.netronome.com>
In-Reply-To: <20191015100057.19199-1-jiri@resnulli.us>
References: <20191015100057.19199-1-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Oct 2019 12:00:56 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Recently couple of files that are write only were added to netdevsim
> debugfs. Don't read these files and avoid error.
> 
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  tools/testing/selftests/bpf/test_offload.py | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
> index 15a666329a34..c44c650bde3a 100755
> --- a/tools/testing/selftests/bpf/test_offload.py
> +++ b/tools/testing/selftests/bpf/test_offload.py
> @@ -312,7 +312,7 @@ class DebugfsDir:
>              if f == "ports":
>                  continue
>              p = os.path.join(path, f)
> -            if os.path.isfile(p):
> +            if os.path.isfile(p) and os.access(p, os.R_OK):

Have you tested this? Looks like python always returns True here when
run as root, and this script requires root (and checks for it).

Also the fix is needed in net, not sure why you sent it to net-next.

>                  _, out = cmd('cat %s/%s' % (path, f))
>                  dfs[f] = out.strip()
>              elif os.path.isdir(p):
