Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADB7170297
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 16:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgBZPfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 10:35:25 -0500
Received: from www62.your-server.de ([213.133.104.62]:39820 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbgBZPfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 10:35:24 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j6yiV-0000f0-Ux; Wed, 26 Feb 2020 16:35:21 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j6yiV-000QnW-GW; Wed, 26 Feb 2020 16:35:19 +0100
Subject: Re: [PATCH bpf-next v3 2/5] bpftool: Make probes which emit dmesg
 warnings optional
To:     Michal Rostecki <mrostecki@opensuse.org>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
References: <20200225194446.20651-1-mrostecki@opensuse.org>
 <20200225194446.20651-3-mrostecki@opensuse.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9398747e-2ebe-074b-afea-3d0ba7555479@iogearbox.net>
Date:   Wed, 26 Feb 2020 16:35:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200225194446.20651-3-mrostecki@opensuse.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25734/Tue Feb 25 15:06:17 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/20 8:44 PM, Michal Rostecki wrote:
> Probes related to bpf_probe_write_user and bpf_trace_printk helpers emit
> dmesg warnings which might be confusing for people running bpftool on
> production environments. This change filters them out by default and
> introduces the new positional argument "full" which enables all
> available probes.
> 
> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
[...]
> +		/* Skip helper functions which emit dmesg messages when not in
> +		 * the full mode.
> +		 */
> +		switch (id) {
> +		case 6: /* trace_printk */
> +		case 36: /* probe_write_user */

Please fix this into the actual enum above, then also the comment is not needed.

> +			if (!full_mode)
> +				continue;
> +			/* fallthrough */
> +		default:
> +			probe_helper_for_progtype(prog_type, supported_type,
> +						  define_prefix, id, ptype_name,
> +						  ifindex);
>   		}
>   	}
