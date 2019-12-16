Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DECB4120FE5
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfLPQoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:44:00 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45439 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLPQn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:43:59 -0500
Received: by mail-qk1-f193.google.com with SMTP id x1so5714974qkl.12
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 08:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=giWyTFAPwDtufMlSK4ZUn2U0mRssejITXnVtTgJpDNY=;
        b=KcvVK8mJw0ahEKynNX69yOCeFTJ6zfpQA/G9XAss/yjj+t/VpyRA92oBDbOvHtQFv+
         Cz5ck9bC5QrVILfuNSf4M5nG0lK0BY1Jr+HD6lSyT0lvBR10d4jqlzktiTrpiodq3cD6
         dD69K7Q7BF5aXaYf7Lff6cSF0sBhd6WSE4gN5SxGwC5mRS3U76aI0+f2I6fj+dPh75dH
         FKciuRXOi04/vchqwZFO9nZx9lIDP1r6w/blRZrmO2rApsbq04g2QHdda0mGr99xjjht
         UkR0omdVSPgfSO3wE3e+izav2jCU1tbb5Vo5BqmYu6WH2bLdyHDdxQculDerNXCuwIgl
         DynA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=giWyTFAPwDtufMlSK4ZUn2U0mRssejITXnVtTgJpDNY=;
        b=bE3fnljbTOrZn4GgjPGSONHuCqaee+yEyLZgfV5rFPbvKA5naFf7Ik1BY3mY9df9PH
         e1E7/RkTpXPmEHEvNAIBa00nh47cE7ATnbJcbXnyFzAjFyO082TWeTkfX0L7UrTjoEUV
         ENhUrxvdHKYpcxXc3Ulm4FgaeuujNcyM+u7YePamY1N4FEZlDcdD+frRoLnLq8r9Tozd
         cMvCWJ0AXt8g/Q/aqEDmH/2cdJenxBZhHRUWMWaLbxZ4cZc6FhHKVJTXrTy4DlxyejC6
         pCnb/D2DapKxW53WCK+L3EEAoLKuW+6RYkjHCcLrkdBVFjHzciQko58wl3LAwWUvEdJH
         2sbg==
X-Gm-Message-State: APjAAAV3jfs6mImcl/+j3UxN4CJ5XjVLByvwvK9Hb8T+xNO6yanhzED4
        Q6ErCvi5GVeCcCYC5jNKeXs=
X-Google-Smtp-Source: APXvYqw6YzkLYAyOKGboWII+7mzc2PDdw5WEQQBBuxeCQiKqOHn+O/XUf2iqWJK5xwdFmeQNKDc5AQ==
X-Received: by 2002:a37:ae07:: with SMTP id x7mr177568qke.28.1576514638917;
        Mon, 16 Dec 2019 08:43:58 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:c48d:b570:ebb:18d9? ([2601:284:8202:10b0:c48d:b570:ebb:18d9])
        by smtp.googlemail.com with ESMTPSA id l49sm7121380qtk.7.2019.12.16.08.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 08:43:57 -0800 (PST)
Subject: Re: [PATCH net-next v2 06/10] ipv4: Handle route deletion
 notification
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20191214155315.613186-1-idosch@idosch.org>
 <20191214155315.613186-7-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5897ce43-0475-b9b9-4508-40914a27977b@gmail.com>
Date:   Mon, 16 Dec 2019 09:43:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191214155315.613186-7-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/19 8:53 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> When a route is deleted we potentially need to promote the next route in
> the FIB alias list (e.g., with an higher metric). In case we find such a
> route, a replace notification is emitted. Otherwise, a delete
> notification for the deleted route.
> 
> v2:
> * Convert to use fib_find_alias() instead of fib_find_first_alias()
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  net/ipv4/fib_trie.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


