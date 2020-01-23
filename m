Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B47147328
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 22:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgAWVdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 16:33:03 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:41529 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAWVdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 16:33:03 -0500
Received: by mail-qv1-f65.google.com with SMTP id x1so2228755qvr.8
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 13:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AAmohKQhIx/PVc+zFENj878NiOi2R1PlMXpgOVuAFo8=;
        b=Ffpl5UldaoaVPUnHVh53T+FqCR634GkHrdZqdwQDIuO+fUySD+qIy3kotrJqZWkj64
         9eOoXKyZq+Zf4uOiNPAwge6ig2yEF0YDi/Z73MXi51XixagiTCCL28M+VwJ4lr737i+2
         zyG6QiHjm8EhGqNflSz7RjhfGsckrzFUyYG82udADl1p38kRaePqqgGry1Xb/vWI3ejU
         zYUud48/krLh8PnpZ+e/i/NByPMgBoQHgATvbU9cS+q5akrHemhIjBcKEk86NQY51ji0
         6sI8Y528swZ7yjaLwUYGFftfFoaBZg2y/uOAUYbPoJjoeNEiT1t+ErQsD4SZU4FeXk45
         8g+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AAmohKQhIx/PVc+zFENj878NiOi2R1PlMXpgOVuAFo8=;
        b=DYw3ID0rGSFtTGmCrK46yZ8KmfcX01/qnhIueJ0Lw+ml8Pq3pZ7eOk1i/94oLD4pOC
         5NjLjoGbXd+hTL0xb1gSr9eaIjA1w/wWg2lg9IWGySrErYLQt9GpWp//ey+GFPExf77Z
         LiirtnsUXrsT+LlsHToASeggDd/T73MbO2H6goxxTSDV5j5SvHME94EpLKSadcVfTSzk
         2wwfPzaKy3Fq8mLtQL9KuTgmjZf9wIzB6xKORXFz5yu7n5PDU0+ZevkjPtslZVPrEQoZ
         OuPDgWld2Aam8Rxxkn11dAWcr5j3v4k920Nvm0Q5VMDAo5wdTZiVjFPv6VCu/LhM9ZCi
         H9/g==
X-Gm-Message-State: APjAAAU9VIc3atlsnBp+ffLsFPuEXd1ray5Z9nW6OV9/luYmKj9Q0Ycy
        zoB5yRmDBAVRdf8rvpH/vOM=
X-Google-Smtp-Source: APXvYqyoWwmEKfeWmuNVmBaksx8JlX7dmTJp1iylq8kzUDsrf7H7C8eRkESlIPV1g0xY1kP/4KnHCQ==
X-Received: by 2002:ad4:4389:: with SMTP id s9mr17696625qvr.99.1579815182363;
        Thu, 23 Jan 2020 13:33:02 -0800 (PST)
Received: from [10.10.4.153] ([38.88.53.90])
        by smtp.googlemail.com with ESMTPSA id x3sm1740816qts.35.2020.01.23.13.33.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 13:33:01 -0800 (PST)
Subject: Re: [PATCH bpf-next 02/12] net: Add BPF_XDP_EGRESS as a
 bpf_attach_type
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jbrouer@redhat.com, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-3-dsahern@kernel.org> <87wo9i9zkc.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4e5cda5b-30be-751a-be74-6f10b2978a8f@gmail.com>
Date:   Thu, 23 Jan 2020 14:32:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87wo9i9zkc.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/20 4:34 AM, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@kernel.org> writes:
> 
>> From: Prashant Bhole <prashantbhole.linux@gmail.com>
>>
>> Add new bpf_attach_type, BPF_XDP_EGRESS, for BPF programs attached
>> at the XDP layer, but the egress path.
>>
>> Since egress path does not have rx_queue_index and ingress_ifindex set,
>> update xdp_is_valid_access to block access to these entries in the xdp
>> context when a program is attached to egress path.
> 
> Isn't the whole point of this to be able to use unchanged XDP programs?

See patch 12. Only the userspace code was changed to load the same
program with the egress attach type set.

The verifier needs to check the egress program does not access Rx only
entries in xdp_md context. The attach type allows that check.

> But now you're introducing a semantic difference. Since supposedly only
> point-to-point links are going to be using this attach type, don't they
> know enough about their peer device to be able to populate those fields
> with meaningful values, instead of restricting access to them?
> 

You are conflating use cases. Don't assume point to point or peer devices.

This could be a REDIRECT from eth0 to eth1 and then an EGRESS program on
eth1 to do something. In the current test scenario it is REDIRECT from
eth0 to tapN and then on tapN run an egress program (Tx for a tap is
ingress to the VM).
