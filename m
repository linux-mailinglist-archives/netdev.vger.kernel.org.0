Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABE10E1EFA
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 17:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392429AbfJWPLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 11:11:43 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40157 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390140AbfJWPLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 11:11:43 -0400
Received: by mail-pl1-f193.google.com with SMTP id d22so10226488pll.7
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 08:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nxZHPw5roAfWVJbgnFWGD4UhB7WI8aYf9WH2YUHBrNk=;
        b=h/HfsuJBhqg9IUzZyDkZgem21gyX0uQkVWbTUA47dUJ5ieT8O6PUsAuv2xbHEN9AEu
         DiC0Qs6EtuhHmY7im6ysIkgBy9JOkfzS7fno3ueR/Vx7lDjFHOsVt8nNCk/vFRLscfFh
         Qe+nX4AGR3pGp7TwNMkvZ8wO37tCr7rJvp+u2EWl49kE3NpYR05Ss3+um0mbxqnXOl3I
         CgfWO9tbxovU2TwLqb884Xlk1cHz1+CQ6qIN2YzdGFm9ICWwJ0WzP58uxiXQB0rTsUx/
         PkYC1e2r130I8ni3ZRl63qsHKbor25zNjyfNKB/KljHnNhQLdfrlKQsOy3wEEKUtEkq4
         gJcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nxZHPw5roAfWVJbgnFWGD4UhB7WI8aYf9WH2YUHBrNk=;
        b=jweput1Z891PL1cfL37hxUgXcXhkFM8IK209CPGBtEOheO5nPKqQ5NSBKzihkj7wnD
         oLMWhcNVygIOndtkAEejSNGF2lMcU97hxRlqDwYl/DZNn8aORCkhuEdC5gT8IKAFyJoE
         u8s3m+Wkl2N6pD7aEGI+YvCxOYUkpH5a8AUFVH2hnRioLgcBcUxiR2pYOAuAe1LTTO68
         DbEjp2Uc2vljbXOR7PTs2omeNgsNez4kMKiX9w+NSHRBcSSHUqz6jSrFI0h+q0NKe1PZ
         mZGeo/riXiv09a6v1wSpK/jnAxJ/ITlABZbazzGTy/jcQ6rtnKfYEnx5uBwvMevL+cWP
         ULPA==
X-Gm-Message-State: APjAAAU9BfGEX7tFW8fnFFVNws/Lo0cH8xZG8KQVwoje30NBTCBZrxFC
        iMoY9DNu9Lb1S+kfW8P5ROI=
X-Google-Smtp-Source: APXvYqxsWhWXk5khgUGRVmXy8QaxHr8piNZIJ/bsNqlLjJZJ557VnfuQX4DNATwxd8dsFo8OLPmicg==
X-Received: by 2002:a17:902:8d97:: with SMTP id v23mr10130648plo.17.1571843502796;
        Wed, 23 Oct 2019 08:11:42 -0700 (PDT)
Received: from [172.27.227.214] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id l184sm24008168pfl.76.2019.10.23.08.11.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 08:11:41 -0700 (PDT)
Subject: Re: [patch iproute2-next v4 1/3] lib/ll_map: cache alternative names
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        stephen@networkplumber.org, roopa@cumulusnetworks.com,
        dcbw@redhat.com, nikolay@cumulusnetworks.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        f.fainelli@gmail.com, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
References: <20191019173749.19068-1-jiri@resnulli.us>
 <20191019173749.19068-2-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0aa53f9c-b038-ff66-6e0e-65fe3bd3ee64@gmail.com>
Date:   Wed, 23 Oct 2019 09:11:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20191019173749.19068-2-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/19 11:37 AM, Jiri Pirko wrote:
> +static void ll_altname_entries_destroy(struct ll_cache *parent_im)
> +{
> +	struct ll_cache *im;
> +
> +	list_for_each_entry(im, &parent_im->altnames_list, altnames_list)
> +		ll_entry_destroy(im, false);

you are walking a list and removing elements from it, so that should be
list_for_each_entry_safe, no?

