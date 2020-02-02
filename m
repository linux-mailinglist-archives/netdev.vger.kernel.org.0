Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B809714FEA9
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 18:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgBBRpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 12:45:30 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:34222 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbgBBRpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 12:45:30 -0500
Received: by mail-io1-f67.google.com with SMTP id z193so14119342iof.1
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 09:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V+GxuCm0hAdY9xVRHiAVt3gl8Cp4yF/0HXYsgQOSkQk=;
        b=vRBNveStpfCCBgJIZtxsh6swEzZQ+VsyA2wLFDxwd6e0E9uYXn4X1zYkRwHcVQkI+v
         rEsI79j7elWvj7oizWkVlIUcnyqoElq6nPyufySg3NcacIuK7ngL6lGPJ6rQou4AWWRu
         8zfoiW33lAiv0F5QbO4K1U4kC3kumOvkIF/GuAEWU8iNvKFIiyckLeKQxajtqpFRRUgc
         BCtlZr1psr05nifY0jbTeMHiXIZysCfu3kQiUHQVl7CQMDmrooXLuH2gZ/YMKJ9gHaJA
         B80YomZLIsQMlXAJUaVtVGd6/eZ0F+3Wy6OCxsPjp0cs0mFzo2Rp4Fv58TJRrNXDsTTA
         1qfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V+GxuCm0hAdY9xVRHiAVt3gl8Cp4yF/0HXYsgQOSkQk=;
        b=Eu6D+LdYC7IyO1OAUwvPtGufmW0qSVAP9BenqAs7WqDEx8L+DYFyw/w+AIYXn+RHJA
         9sdicRTKL6BZzzisNCJUu32ovg7TdStpMwlFeLD45+4/LCdNv1p7xs7xZ+WbV3VPWVlE
         0BcDtrc2CCbX1XLcbqWBZ4I3/QHr74M4hYU6E1lNq0ykHf6D030yYjB1/XAyatkjTbHu
         jUqY0TIemNOo4wbxaWEFSnO+AXEjgMJjr590GIAEXXkVeeWTeBWT8HGzBQtmFA0pk5fh
         XQuSLZ6u1tTWu3UMg155cYpaMS4eEG2tqENipET3A83901vbwjfDCOuVIS8oRWaVqhuS
         +ZGA==
X-Gm-Message-State: APjAAAUDaovxuqQS7iOYHwoES26guqbgZiF0sLEG7LiAnc3HeE2W3NMv
        sr+e/fp2o7FF8y8gf0YHhO8=
X-Google-Smtp-Source: APXvYqzsgxKNqQ5Q7FqtFNcUVejfNmIzUp56Y7GwMG5MWGUQ1QzGkZileKWy66YjZFroFixfbb23Eg==
X-Received: by 2002:a5e:840f:: with SMTP id h15mr17073149ioj.286.1580665529367;
        Sun, 02 Feb 2020 09:45:29 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:2529:5ed3:9969:3b0e? ([2601:282:803:7700:2529:5ed3:9969:3b0e])
        by smtp.googlemail.com with ESMTPSA id q8sm4714243ion.57.2020.02.02.09.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Feb 2020 09:45:28 -0800 (PST)
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs
 in the egress path
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk>
 <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
 <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk>
 <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
 <20200126141141.0b773aba@cakuba>
 <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com>
 <20200127061623.1cf42cd0@cakuba>
 <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com>
 <20200128055752.617aebc7@cakuba> <87ftfue0mw.fsf@toke.dk>
 <20200201090800.47b38d2b@cakuba.hsd1.ca.comcast.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f821e692-59cf-ae58-f34f-7bab6a702b46@gmail.com>
Date:   Sun, 2 Feb 2020 10:45:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200201090800.47b38d2b@cakuba.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/20 10:08 AM, Jakub Kicinski wrote:
> If EGRESS is only for XDP frames we could try to hide the handling in
> the core (with slight changes to XDP_TX handling in the drivers),

It is not. I have said multiple times it is to work on ALL packets that
hit the xmit function, both skbs and xdp_frames.
