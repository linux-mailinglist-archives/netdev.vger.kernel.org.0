Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7289A1A2C85
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 01:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgDHXoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 19:44:21 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45847 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgDHXoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 19:44:21 -0400
Received: by mail-qt1-f193.google.com with SMTP id 71so1406912qtc.12;
        Wed, 08 Apr 2020 16:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sYnGyVWgviMfWxmYkoIJzYP448uaDBVGgnoVjN/5M7c=;
        b=hcBeg768dJ4c4xt8soG0eTXUj9p+zHhgE7Wf8v6NYb7v/9LBXkgWaGqXGo8oTo2jHP
         0fb13j9ooFFT1DTZidZVtlLDNuLbZkF2CdbJNSRTpkzGTalHDs/tKRgxTpwTEqI0gpDH
         ZJ93QDQmMeFckLjr05KdGAP8xKeZ9Ne30z1qYY3EmFUDe8zBYXFga4yQ6XIFpWLivbWN
         aw84SSsuwpXXUyue+6IG5wZ+hivH3RW5HRoxGnvgiLE+vM4647MzOm0PnLjdjYgNpBCv
         OzMbZtKOi7i/Fwd+N6jn2zVat+TBwxg6NBj7w7W/9G+uQRPJV/fFhIzg30a46rZsEyJB
         MCGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sYnGyVWgviMfWxmYkoIJzYP448uaDBVGgnoVjN/5M7c=;
        b=Q6ANRuyf+F6ilMNx1QZjnUYVZLNCmsvssEiaBI2/jvSuIb9r6xWm6zi5M53Yt2l1XK
         kqI0Ezx0wov/qx7LYWto+wbmtRb15ZUV0OGZoouX6I/hIgtk3WK6e9Wq4LHXWMSTfaX8
         KvBbiBR4OnjvISR+0exWQIycMA96PJxKoQHSCcy3WN4nZTOWIrNl9L46oz7ljuCr8mvy
         dDXHvylDQ0AP2XgnQ5uthxaybf9Q9KiD5anXi0eLgPUdTEDFTthk6WFB1r/A9iPhBiKj
         RoOtG57EgicOihcxJi7eTJsvKY61pYPf3u22+LZ9UnJQ1NXfY51tvoEXzs3+OlwRtSgj
         uvrg==
X-Gm-Message-State: AGi0PuaFUNMTG4gw1MI0Y3uIfWtM6HOaDELKxMXqYoLfhB96y93PMsL9
        uxsr6NT+xezhe1VAFsyakUE=
X-Google-Smtp-Source: APiQypLc1xIQrpJaQ5S1JU2hBH0+5NLsPkWxadrZUhmG6ibWV12ErjoXbHEB9eGsQQvlpCgC4/q8UA==
X-Received: by 2002:ac8:22ad:: with SMTP id f42mr1728918qta.292.1586389460669;
        Wed, 08 Apr 2020 16:44:20 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:440d:6925:c240:4cc1? ([2601:282:803:7700:440d:6925:c240:4cc1])
        by smtp.googlemail.com with ESMTPSA id f16sm15018640qto.59.2020.04.08.16.44.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 16:44:20 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next 8/8] bpftool: add bpf_link show and pin
 support
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200404000948.3980903-1-andriin@fb.com>
 <20200404000948.3980903-9-andriin@fb.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1dbaaf27-af89-f6d5-bb09-8e1b967c9582@gmail.com>
Date:   Wed, 8 Apr 2020 17:44:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200404000948.3980903-9-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/3/20 6:09 PM, Andrii Nakryiko wrote:
> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> index 466c269eabdd..4b2f74941625 100644
> --- a/tools/bpf/bpftool/main.c
> +++ b/tools/bpf/bpftool/main.c
> @@ -30,6 +30,7 @@ bool verifier_logs;
>  bool relaxed_maps;
>  struct pinned_obj_table prog_table;
>  struct pinned_obj_table map_table;
> +struct pinned_obj_table link_table;
>  
>  static void __noreturn clean_and_exit(int i)
>  {
> @@ -215,6 +216,7 @@ static const struct cmd cmds[] = {
>  	{ "batch",	do_batch },
>  	{ "prog",	do_prog },
>  	{ "map",	do_map },
> +	{ "link",	do_link },
>  	{ "cgroup",	do_cgroup },
>  	{ "perf",	do_perf },
>  	{ "net",	do_net },

you need to add 'link' to the OBJECT list in do_help.
