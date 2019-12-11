Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62AA611BA80
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbfLKRkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:40:13 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35122 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729512AbfLKRkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:40:13 -0500
Received: by mail-qt1-f194.google.com with SMTP id s8so7023007qte.2
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pjdix2aDvTkEOzMzyJJYaAIfeJY+e8hVL0eYKBK4+Ds=;
        b=MjkcFm7Dwm32K6CSXA/migBaKWEEr/Fm30TPworNBAyUYAkAem94WHGkLKqUBvkRd+
         jrwYZxkm08SbFICxkON9mhSrJGDM95ZZayCKWohNPgCpHow18prIUrqSYCEGYqDx7sUT
         7ubOME+6ZZXiZ1UWo3omxKoltOn9tLAihTFSqJ2zWDG4qteTDcJTM0cuz3mU0xTJd0ai
         zOi4ahPa/8xqgD/iqfdrRribgP7dlc9ojLkMoE0A5olbRiRxLaDII+f1xZ+LLYn+9ZNH
         8wgRmCP0r30Z1VTdHOBq3E9fJCTFMjO6BA3BL5AVGD6E7L+f5S3WgDoLaYlo7RqMKZVT
         TcKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pjdix2aDvTkEOzMzyJJYaAIfeJY+e8hVL0eYKBK4+Ds=;
        b=TCBVYu3v8KoW5rdAEYSEqt0rPVms7xM/5t+RjaSawrusErR9bUNCb/3zoAb0ijp0DN
         j2uqeMNUenEpFIT0ifVe6fUHiKIiv4U7Ab62PgV/P8rZUazpGBt9xjbNLYT8DEwktrTc
         y3WBYyTeu626TUhZzx1/VxmoAx07oJk95v4zBud7KZxBGaz5EdJ4Yp/qECjQDe9W+M1K
         cw0Lij6xywiRFbuQilBfRF8zG3gidYWV41feuMXALtkQEfOFx+V6qRSl4GEvm9YcGSRN
         szpZ+odAVuKIPvsa275xKj9nJScRPUH0zMpW3CG7txH9xIQxUR84SnpYhdH3oRQLd2Jd
         T14g==
X-Gm-Message-State: APjAAAUpi4BUhM1R0jw5ZMLWJ3sdTU1mOkVWQM68Ag/PyvUanAF2DiMf
        W3/DG2y+C2l2WUKlVT1SR9w=
X-Google-Smtp-Source: APXvYqzBcx1veploBM7AbIY2MYWJqhnuWWokOaVsOtOpZH8A64vln1Jmv7NVvKWXQdFuh4pvucP6og==
X-Received: by 2002:ac8:788:: with SMTP id l8mr3825453qth.267.1576086012520;
        Wed, 11 Dec 2019 09:40:12 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:79bb:41c5:ccad:6884? ([2601:282:800:fd80:79bb:41c5:ccad:6884])
        by smtp.googlemail.com with ESMTPSA id u57sm1134475qth.68.2019.12.11.09.40.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 09:40:11 -0800 (PST)
Subject: Re: [PATCH net-next 3/9] ipv4: Notify route if replacing currently
 offloaded one
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20191210172402.463397-1-idosch@idosch.org>
 <20191210172402.463397-4-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <112373c1-cdb6-86bf-33ac-f555b93db735@gmail.com>
Date:   Wed, 11 Dec 2019 10:40:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191210172402.463397-4-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/19 10:23 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> When replacing a route, its replacement should only be notified in case
> the replaced route is of any interest to listeners. In other words, if
> the replaced route is currently used in the data path, which means it is
> the first route in the FIB alias list with the given {prefix, prefix
> length, table ID}.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  net/ipv4/fib_trie.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> index 9264d6628e9f..6822aa90657a 100644
> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
> @@ -978,6 +978,27 @@ static struct key_vector *fib_find_node(struct trie *t,
>  	return n;
>  }
>  
> +/* Return the first fib alias matching prefix length and table ID. */
> +static struct fib_alias *fib_find_first_alias(struct hlist_head *fah, u8 slen,
> +					      u32 tb_id)
> +{
> +	struct fib_alias *fa;
> +
> +	hlist_for_each_entry(fa, fah, fa_list) {
> +		if (fa->fa_slen < slen)
> +			continue;
> +		if (fa->fa_slen != slen)
> +			break;
> +		if (fa->tb_id > tb_id)
> +			continue;
> +		if (fa->tb_id != tb_id)
> +			break;
> +		return fa;

Rather than duplicating fib_find_alias, how about adding a 'bool
find_first' argument and bail on it:

		if (find_first)
			return fa;

		continue to tos and priority compares.

> +	}
> +
> +	return NULL;
> +}
> +
>  /* Return the first fib alias matching TOS with
>   * priority less than or equal to PRIO.
>   */
> @@ -1217,6 +1238,17 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
>  			new_fa->tb_id = tb->tb_id;
>  			new_fa->fa_default = -1;
>  
> +			if (fib_find_first_alias(&l->leaf, fa->fa_slen,
> +						 tb->tb_id) == fa) {
> +				enum fib_event_type fib_event;
> +
> +				fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
> +				err = call_fib_entry_notifiers(net, fib_event,
> +							       key, plen,
> +							       new_fa, extack);
> +				if (err)
> +					goto out_free_new_fa;
> +			}
>  			err = call_fib_entry_notifiers(net,
>  						       FIB_EVENT_ENTRY_REPLACE,
>  						       key, plen, new_fa,
> 

