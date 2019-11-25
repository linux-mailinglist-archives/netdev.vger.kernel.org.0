Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6961C10864A
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 02:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfKYBYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 20:24:45 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39452 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbfKYBYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 20:24:45 -0500
Received: by mail-pl1-f196.google.com with SMTP id o9so5735731plk.6;
        Sun, 24 Nov 2019 17:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/hR6eIss2IDB1moLZhw+z4nUfFpq/z6nkZpZv3gD0BI=;
        b=bXtDw5MftbTx3shyWLLx6l40rF79G51eiFtaOF+Vr3Sl5x1K2lbcfvmRkacisNjFCv
         7SzHyX58G5g5ngl/YE2x2pgrZnQG0TsHOzljFqx0Joj/oUn5tysNt6iO+tD/LvuijyPN
         dRvsjDaJxVloFbDCbXWuc8KgJYPY2mROJBu0zPBGY9VoDWneGxOnZxZiIrPQokyIyDEG
         g77aw2XJeMDy9JyR5ABDtoZ4VjAZ4Mj2u3fYOv0lehpHXGjRlshiOuL1+Q6nP6bNoKBg
         70biqk/oV7xRXOtBfMpx9RM0+MX60HkYx/uvZEHJfs4uMN5hhx9pS4BFFoexmjkgw7+i
         Kp3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/hR6eIss2IDB1moLZhw+z4nUfFpq/z6nkZpZv3gD0BI=;
        b=IIcErcaq/WN0jgWfnVt7TqAbmK7lrT02TUfK3O9S3kLiqu4Gu4zGQFjt0RpW4tum58
         pYtC4n0AsL1OoM8UcucZ6KgaWv+HHif/bGN0u+rVPYjYmfeMlLSKw4FNpbPhO05y+F2y
         3naX07JUuM3O81CkLlpIGWsAn8V/RPyW+0BHWvdR1+YMz+74H+YTsuCNJTw1cCKG4bMO
         Dj4dimyAY5eHNNToFuo+LrKrt9d3nw+wkULUjZOoZIqiruBUvSDVV8PAE36bGuqKJZmo
         1EIHBdRD9viDh2VmHBoIXjfKiDLxqy6G1NbaI3DihkeRCPGeQXPC33ois8vIZ5aUjWVl
         JBcg==
X-Gm-Message-State: APjAAAWzpOq5G+trHCy8LPuBGuHbXgCuumDRXMN/MkfuSDvTFOuk2Us2
        QOmys84c91jy3eVzmiG6KX8=
X-Google-Smtp-Source: APXvYqxsUeWTaK6lDvuXN/ARoyOnX/4ZmOKeBJo3q96Gjr3Q632CjBC6ZLl7fwczKAbbKxK9lLgGIg==
X-Received: by 2002:a17:90a:25ea:: with SMTP id k97mr34238006pje.110.1574645084079;
        Sun, 24 Nov 2019 17:24:44 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::6b6f])
        by smtp.gmail.com with ESMTPSA id x2sm5738495pgc.67.2019.11.24.17.24.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Nov 2019 17:24:43 -0800 (PST)
Date:   Sun, 24 Nov 2019 17:24:41 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next 5/8] bpf: Allow selecting reuseport socket from
 a SOCKMAP
Message-ID: <20191125012440.crbufwpokttx67du@ast-mbp.dhcp.thefacebook.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-6-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191123110751.6729-6-jakub@cloudflare.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 12:07:48PM +0100, Jakub Sitnicki wrote:
> SOCKMAP now supports storing references to listening sockets. Nothing keeps
> us from using it as an array of sockets to select from in SK_REUSEPORT
> programs.
> 
> Whitelist the map type with the BPF helper for selecting socket. However,
> impose a restriction that the selected socket needs to be a listening TCP
> socket or a bound UDP socket (connected or not).
> 
> The only other map type that works with the BPF reuseport helper,
> REUSEPORT_SOCKARRAY, has a corresponding check in its update operation
> handler.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  kernel/bpf/verifier.c | 6 ++++--
>  net/core/filter.c     | 2 ++
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index a0482e1c4a77..111a1eb543ab 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3685,7 +3685,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>  		if (func_id != BPF_FUNC_sk_redirect_map &&
>  		    func_id != BPF_FUNC_sock_map_update &&
>  		    func_id != BPF_FUNC_map_delete_elem &&
> -		    func_id != BPF_FUNC_msg_redirect_map)
> +		    func_id != BPF_FUNC_msg_redirect_map &&
> +		    func_id != BPF_FUNC_sk_select_reuseport)
>  			goto error;
>  		break;
>  	case BPF_MAP_TYPE_SOCKHASH:
> @@ -3766,7 +3767,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>  			goto error;
>  		break;
>  	case BPF_FUNC_sk_select_reuseport:
> -		if (map->map_type != BPF_MAP_TYPE_REUSEPORT_SOCKARRAY)
> +		if (map->map_type != BPF_MAP_TYPE_REUSEPORT_SOCKARRAY &&
> +		    map->map_type != BPF_MAP_TYPE_SOCKMAP)
>  			goto error;
>  		break;
>  	case BPF_FUNC_map_peek_elem:
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 49ded4a7588a..e3fb77353248 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -8723,6 +8723,8 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
>  	selected_sk = map->ops->map_lookup_elem(map, key);
>  	if (!selected_sk)
>  		return -ENOENT;
> +	if (!sock_flag(selected_sk, SOCK_RCU_FREE))
> +		return -EINVAL;

hmm. I wonder whether this breaks existing users...
Martin,
what do you think?
Could you also take a look at other patches too?
In particular patch 7?

