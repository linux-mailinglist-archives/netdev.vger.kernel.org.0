Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE6F2140419
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 07:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbgAQGnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 01:43:31 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:5723 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgAQGnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 01:43:31 -0500
Received: from [10.193.191.49] (ayushsawal.asicdesigners.com [10.193.191.49])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 00H6h97R009989;
        Thu, 16 Jan 2020 22:43:10 -0800
Cc:     ayush.sawal@asicdesigners.com, linux-crypto@vger.kernel.org,
        manojmalviya@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>,
        netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: Advertise maximum number of sg supported by driver in single
 request
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <20200115060234.4mm6fsmsrryzpymi@gondor.apana.org.au>
 <9fd07805-8e2e-8c3f-6e5e-026ad2102c5a@chelsio.com>
 <c8d64068-a87b-36dd-910d-fb98e09c7e4b@asicdesigners.com>
 <20200117062300.qfngm2degxvjskkt@gondor.apana.org.au>
From:   Ayush Sawal <ayush.sawal@asicdesigners.com>
Message-ID: <20d97886-e442-ed47-5685-ff5cd9fcbf1c@asicdesigners.com>
Date:   Fri, 17 Jan 2020 12:13:07 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200117062300.qfngm2degxvjskkt@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Herbert,

On 1/17/2020 11:53 AM, Herbert Xu wrote:
> On Thu, Jan 16, 2020 at 01:27:24PM +0530, Ayush Sawal wrote:
>> The max data limit is 15 sgs where each sg contains data of mtu size .
>> we are running a netperf udp stream test over ipsec tunnel .The ipsec tunnel
>> is established between two hosts which are directly connected
> Are you actually getting 15-element SG lists from IPsec? What is
> generating an skb with 15-element SG lists?
we have established the ipsec tunnel in transport mode using ip xfrm.
and running traffic using netserver and netperf.

In server side we are running
netserver -4
In client side we are running
"netperf -H <serverip> -p <port> -t UDP_STREAM  -Cc -- -m 21k"
where the packet size is 21k ,which is then fragmented into 15 ip 
fragments each of mtu size.
The mtu size currently is 1500bytes.
