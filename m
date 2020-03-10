Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A73F17EE7A
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgCJCSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:18:21 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:42321 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgCJCSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 22:18:21 -0400
Received: by mail-qv1-f65.google.com with SMTP id ca9so2281702qvb.9
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 19:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lJwQTcPBEWiKs5Cf6q3pYBQhE6eqMXLnZ0CSfrjwWiU=;
        b=Up8W45Hk80GNFledDwONZ7Dmxi4bFp8t6aRT2xw7bidsmenPIGX+pPignJ61WNDjZ+
         1gg2ND93/30FhiQaajcfypGSxZo3xfmVI99BdVSUGb9M7LpnBImy1Dmbj1aMsqYccBGc
         fHkyPv+QPjdxnsKvX9WUxluL9MIkzMG3xU3h4I4gzrpDkRfl3Gi9OtXZbWxSC/s2rQ/d
         ljawqk/tcUTwu3WQKPYa8T0e1uffCPwvC8LWhOxic9OSiB7g0KuJPR1NKTdxpRrLjbZw
         rtB1em7BUuWIyzjraJH2PiGQo24Lx+PueYtKIUfBPPwcKtTOZp2J1koaiPLwM3DZAV8X
         u3HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lJwQTcPBEWiKs5Cf6q3pYBQhE6eqMXLnZ0CSfrjwWiU=;
        b=K8O5tCtRIrAhDtCyi6Yd1XENcXIWjBCAp7OSGdnShhovICU7wcKRrlXKrXWxUo42iG
         Tt9ZCsHPCcC2R0B2+W8oNR5dbYqvUCZFgHHp7mIP0yi5hv6OiCZ8qTqV4eZMZ1lp+326
         OJga8HgiNbbnQMLcmNGmfmndDBk9uQChgJBMe/CuuNqABr9IzM90w365eknpe//ZiUBo
         ROMu+RQ1MT00Jo07fzSs3aY2K34wAAfLx2dmtLWgeFd3DZFC4BQSISscGsxuIqA0SlNu
         f1gl5+GYmWgpfaoDM81cU3XwcgCwqC6fPQjxlTD2CXvzymxPiFcRyvy0qV1lhWZvAGNt
         31IQ==
X-Gm-Message-State: ANhLgQ0pzm7eU72Q1VFp9ELma6W8IDYEakQlVl2kmpewp788TKWDq/CH
        8fINlvqV3PCqg0yT0VxeaZg=
X-Google-Smtp-Source: ADFU+vunR+tejFymEL9bGdpP8AN+6IVgL7z53jG+9wGyL2OpFBBcUt3IJZlcSm4jVdQLpjwEe+KqxQ==
X-Received: by 2002:a0c:ef4f:: with SMTP id t15mr17139990qvs.137.1583806700398;
        Mon, 09 Mar 2020 19:18:20 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b876:5d04:c7e4:4480? ([2601:282:803:7700:b876:5d04:c7e4:4480])
        by smtp.googlemail.com with ESMTPSA id a27sm10277644qto.38.2020.03.09.19.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 19:18:18 -0700 (PDT)
Subject: Re: [PATCH RFC v4 bpf-next 07/11] tun: set egress XDP program
To:     Jason Wang <jasowang@redhat.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com, toke@redhat.com,
        mst@redhat.com, toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200227032013.12385-1-dsahern@kernel.org>
 <20200227032013.12385-8-dsahern@kernel.org>
 <25d0253e-d1b8-ca6c-4e2f-3e5c35d6d661@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b70fd32f-3b72-ea31-a33f-137b1ad1741d@gmail.com>
Date:   Mon, 9 Mar 2020 20:18:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <25d0253e-d1b8-ca6c-4e2f-3e5c35d6d661@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/1/20 8:32 PM, Jason Wang wrote:
>> @@ -1189,15 +1190,21 @@ tun_net_get_stats64(struct net_device *dev,
>> struct rtnl_link_stats64 *stats)
>>   }
>>     static int tun_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>> -               struct netlink_ext_ack *extack)
> 
> 
> How about accept a bpf_prog ** here, then there's no need to check
> egress when deferencing the pointer?
> 
> 

The egress arg is better. xdp_prog vs xdp_egress_prog is an element of
'struct tun'. tun is currently not needed in tun_xdp and is part of
tun_xdp_set already.
