Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAE72C1ACA
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 02:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbgKXBXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 20:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgKXBXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 20:23:46 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8B6C0613CF;
        Mon, 23 Nov 2020 17:23:45 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id f17so7419710pge.6;
        Mon, 23 Nov 2020 17:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OMYZVmLxvpinIxrZR3tpbtIDXrT2La7cS1aFAtH9vbo=;
        b=TPmItr141Jc1Xz+SViqYaQacSdCX6R7SpeJuCaIkauxmcCS6/vMevcs9tsXMGPqpk8
         uynI+2U5ul7nWn7tPAY7c30xC8Pe6wGpUZDBeWuBJQg4ibmfH298mVdY5uLG86TJFupi
         wtJ6ssCHv1wSvp1NdVe47ps/l7JebzdmJvphQXAoCSw6r/ZNuNIn+W0vNUlHX6BEJrnb
         Bv4Qt8K6tG42X5DNO5fQ7VqFGYXSeQK78uhkOjgAgl2h6y+GJRa0G2E7fNdNDRB63Y+j
         yCmVaasCg08PbJuo17sprazs2GXRhtpSUStP+fuFozi1nWPjTq6VS/ssktFvlsxaRplG
         PBVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OMYZVmLxvpinIxrZR3tpbtIDXrT2La7cS1aFAtH9vbo=;
        b=ZYzh12TJA7FFkBpTfECLpPSg3vr6RWQ1JOPA3h/VmDMR37k2Y4VQLzNlnmiWRxV6iO
         6xLofetDQ5C8vMNCT9yA86FRmCwiz6YLOAguBLVdb6kgo8oaWaBBbJpMJn1Weh40bV0P
         CS3jO1b8oaeS9SuhXLA8l4RCpwqf4PTzrWehSJSnY7bYh1kLNs4NccaTlK4nIavE/fbH
         I2AE08xbTHGJ10bCEMeW8OXHxfnkOFkMv9oXFDf6RHY+mUCOJcQASC8hnqWantEOYHdT
         qPn7BiRM5KQynqkQRW5SHkMjrPE72QgCSF31I2vj4PhRcv8qOkZDlOyRsFsSvw10P2i7
         x3VQ==
X-Gm-Message-State: AOAM530CX2nnLhsXjcIKX+XplC3DpnWx20WHfiVHKE+6nQPSakUfM+1e
        M/AWwiIVcEs0aoofkkolhx9RR+a/Z3k=
X-Google-Smtp-Source: ABdhPJy2Wf3uASqu24uYdW6SjJI64BpcFrwu2xrg2EKjE/aezcbm8m57ukLEBl0VHOyoPkMsMpB4cg==
X-Received: by 2002:a17:90a:eb04:: with SMTP id j4mr1928592pjz.103.1606181025503;
        Mon, 23 Nov 2020 17:23:45 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id r4sm12082154pgs.54.2020.11.23.17.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 17:23:44 -0800 (PST)
Date:   Mon, 23 Nov 2020 17:23:42 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     min.li.xe@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] ptp: clockmatrix: bug fix for idtcm_strverscmp
Message-ID: <20201124012342.GA6592@hoboy.vegasvil.org>
References: <1606162806-14589-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606162806-14589-1-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 03:20:06PM -0500, min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Feed kstrtou8 with NULL terminated string.
> 
> Changes since v1:
> -Use strscpy instead of strncpy for safety.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> ---
>  drivers/ptp/ptp_clockmatrix.c | 60 ++++++++++++++++++++++++++++++-------------
>  tools/bpf/example             | 12 +++++++++
>  tools/bpf/novlan              |  7 +++++
>  3 files changed, 61 insertions(+), 18 deletions(-)
>  create mode 100644 tools/bpf/example
>  create mode 100644 tools/bpf/novlan
> 
> diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
> index e020faf..d4e434b 100644
> --- a/drivers/ptp/ptp_clockmatrix.c
> +++ b/drivers/ptp/ptp_clockmatrix.c
> @@ -103,42 +103,66 @@ static int timespec_to_char_array(struct timespec64 const *ts,
>  	return 0;
>  }
>  
> -static int idtcm_strverscmp(const char *ver1, const char *ver2)
> +static int idtcm_strverscmp(const char *version1, const char *version2)
>  {
>  	u8 num1;
>  	u8 num2;
>  	int result = 0;
> +	char ver1[16];
> +	char ver2[16];
> +	char *cur1;
> +	char *cur2;
> +	char *next1;
> +	char *next2;
> +
> +	if (strscpy(ver1, version1, 16) < 0 ||
> +	    strscpy(ver2, version2, 16) < 0)
> +		return -1;
> +	cur1 = ver1;
> +	cur2 = ver2;
>  
>  	/* loop through each level of the version string */
>  	while (result == 0) {
> +		next1 = strchr(cur1, '.');
> +		next2 = strchr(cur2, '.');
> +
> +		/* kstrtou8 could fail for dot */
> +		if (next1) {
> +			*next1 = '\0';
> +			next1++;
> +		}
> +
> +		if (next2) {
> +			*next2 = '\0';
> +			next2++;
> +		}
> +

All of this looping and ad-hoc string parsing can be make MUCH
simpler by using sscanf() and then comparing the binary values
directly.

>  		/* extract leading version numbers */
> -		if (kstrtou8(ver1, 10, &num1) < 0)
> +		if (kstrtou8(cur1, 10, &num1) < 0)
>  			return -1;
>  
> -		if (kstrtou8(ver2, 10, &num2) < 0)
> +		if (kstrtou8(cur2, 10, &num2) < 0)
>  			return -1;
>  
>  		/* if numbers differ, then set the result */
>  		if (num1 < num2)
> +			return -1;
> +		if (num1 > num2)
> +			return 1;
> +
> +		/* if numbers are the same, go to next level */
> +		if (!next1 && !next2)
> +			break;
> +		else if (!next1) {
>  			result = -1;
> -		else if (num1 > num2)
> +		} else if (!next2) {
>  			result = 1;
> -		else {
> -			/* if numbers are the same, go to next level */
> -			ver1 = strchr(ver1, '.');
> -			ver2 = strchr(ver2, '.');
> -			if (!ver1 && !ver2)
> -				break;
> -			else if (!ver1)
> -				result = -1;
> -			else if (!ver2)
> -				result = 1;
> -			else {
> -				ver1++;
> -				ver2++;
> -			}
> +		} else {
> +			cur1 = next1;
> +			cur2 = next2;
>  		}
>  	}
> +
>  	return result;
>  }
>  

> diff --git a/tools/bpf/example b/tools/bpf/example
> new file mode 100644
> index 0000000..a0ac81f
> --- /dev/null
> +++ b/tools/bpf/example
> @@ -0,0 +1,12 @@
> +  ldh [12]
> +  jne #0x8100, nonvlan
> +  ldh [16]
> +  jne #0x88f7, bad
> +  ldb [18]
> +  ja test
> +  nonvlan: jne #0x88f7, bad
> +  ldb [14]
> +  test: and #0x8
> +  jeq #0, bad
> +  good: ret #1500
> +  bad: ret #0

Looks like this hunk and the next got included by mistake.

Thanks,
Richard

> diff --git a/tools/bpf/novlan b/tools/bpf/novlan
> new file mode 100644
> index 0000000..fe35288
> --- /dev/null
> +++ b/tools/bpf/novlan
> @@ -0,0 +1,7 @@
> +  ldh [12]
> +  jne #0x88f7, bad
> +  ldb [14]
> +  and #0x8
> +  jeq #0, bad
> +  good: ret #1500
> +  bad: ret #0
> -- 
> 2.7.4
> 
