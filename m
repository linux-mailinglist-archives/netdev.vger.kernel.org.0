Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 168669DA85
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 02:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfH0ARM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 20:17:12 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35968 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfH0ARL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 20:17:11 -0400
Received: by mail-io1-f67.google.com with SMTP id o9so41957630iom.3
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 17:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s85OzTJReu+oIW3VJnIwJ9EFty74gLRnV0FZ66qHfIQ=;
        b=T2gqTyKXKViBWlIoQfM0kVPpz5LLofsBm2lH37bVKteeIVYOWIxNH9QfKxwhrpuZNZ
         18V+QMHArWisBAGToUxR/Tj0E302WT7jX7WLFjc82BivFOLWwXQQ3KDXVBDl5tFcXHO+
         t8YS+bgVceSeuODL1TCMZNpzgqjeS0zKRVvNOdl7GiYLVX3CKm04zidW33OeXzo2t4bX
         WjE+xaefd91bQQpgILdLLrQneT3KIW7Zm4dyMqCuMjfGjbDkN1Mv9S58KN8DwbnhWtHT
         gs7QRybrPCNor8FufRTHMOLizTYyaqD5JI8736JaMCrcMvoDWdvh9WTWo2go8t/zI1sr
         4hPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s85OzTJReu+oIW3VJnIwJ9EFty74gLRnV0FZ66qHfIQ=;
        b=OTmn8lr/MHancNaJAIR6j+yyUbvZkMY+5/yoD/o2CZpX/VdMRmlQZAGm+u1NwRhmEU
         GzlQsel6c0NwSPwk3bVqbXzbZqlQ55RdKMtK+bm8m6DfLgl4OVtosGRb/2RAaJc/206v
         BbPqzGbnRLPjUp37R8VKo/m0M7zaKkRfXAJPJqBvFuOP60v2XFT0cQwoQF5I80kK+QRe
         tWuXjWHn6vWdgwM1ExETiAF7mcqb0j4/jnGOvuqGfyPB/5px0ghyq2qqhczvkqo/0XTf
         9g9Hijp4IYQ/TQlfFU9sgJL0j2GwFSOITUq5SnrSmYSJ0o3v9Dv6XXlEYQqUhHkXMoho
         eGbg==
X-Gm-Message-State: APjAAAULoLVYCrb4UZ4mfGyzc3Iu7SngN8hlgXfiSlnBp64ki0DW9yEk
        gyQA5YV27TEP7ioeUk2uckn5lLiA
X-Google-Smtp-Source: APXvYqyDIYDQ6SZt9Bx1PdzMEtXSvDv742tLDfQlpg9yuDR5I1fAbnK+N3TJ7B0tb6ZdTzCI/4tJOA==
X-Received: by 2002:a5e:c00e:: with SMTP id u14mr3591781iol.196.1566865030994;
        Mon, 26 Aug 2019 17:17:10 -0700 (PDT)
Received: from [172.16.99.109] (c-73-169-115-106.hsd1.co.comcast.net. [73.169.115.106])
        by smtp.googlemail.com with ESMTPSA id z9sm18723192ior.79.2019.08.26.17.17.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 17:17:09 -0700 (PDT)
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     David Miller <davem@davemloft.net>
Cc:     jakub.kicinski@netronome.com, jiri@resnulli.us,
        roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        sthemmin@microsoft.com, dcbw@redhat.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        mlxsw@mellanox.com
References: <20190826151552.4f1a2ad9@cakuba.netronome.com>
 <20190826.151819.804077961408964282.davem@davemloft.net>
 <ddd05712-e8c7-3c08-11c7-9840f5b64226@gmail.com>
 <20190826.152525.144590581669280532.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <beb8ec07-f28e-4378-e8dd-fa6fe290377b@gmail.com>
Date:   Mon, 26 Aug 2019 18:17:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190826.152525.144590581669280532.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/19 4:25 PM, David Miller wrote:
> From: David Ahern <dsahern@gmail.com>
> Date: Mon, 26 Aug 2019 16:24:38 -0600
> 
>> On 8/26/19 4:18 PM, David Miller wrote:
>>> I honestly think that the size of link dumps are out of hand as-is.
>>
>> so you are suggesting new alternate names should not appear in kernel
>> generated RTM_NEWLINK messages - be it a link dump or a notification on
>> a change?
> 
> I counter with the question of how much crap can we keep sticking in there
> before we have to do something else to provide that information?
> 

Something a bit stand alone would be a better choice - like all of the
VF stuff, stats, per-device type configuration. Yes, that ship has
sailed, but as I recall that is where the overhead is.

An attribute as basic as a name is the wrong place for that split.
