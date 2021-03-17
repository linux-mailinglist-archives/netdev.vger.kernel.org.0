Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480B533F8FA
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 20:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhCQTQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 15:16:51 -0400
Received: from gateway30.websitewelcome.com ([50.116.127.1]:27328 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232963AbhCQTQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 15:16:48 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2021 15:16:48 EDT
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id DA21FB052
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 13:27:42 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id MatSlI9XpPkftMatSlycnL; Wed, 17 Mar 2021 13:27:42 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NXenw5qbQa2c5Dq+QDdWLszQhEmsUBkGoD/XPih167M=; b=YIGIhpWEJvVG8HRqbV2FOavf5e
        z4XBvqewoGs38Yw1uijefU+jblaYEZX3jAsFQGT70bOJfTE55N8rMY1KGNtoC4UwwqI+EnB4TCV4U
        UIiSLwTOTHY1agewzQwVeiC0NM9z4jIsPJChEtGa+OM/3J4eygBrKUR1TMNvPxikKRGzdWQ3gN9sU
        BoitfNGKnGod/pgFvNHXCEhPvixihJ0j5tyraoC1EGh4tpAmMLcJ1nkPfkmq79Ws3QmiwnlpYExjo
        EyV9EIzTWJwbnW+58OgCHyiCx1HL1Wcory2uOypQ8OpIaym8Ef8APQ48pAhqtcd1/edrr7Ar78qcE
        aHVklH2g==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:58230 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lMatS-001uWQ-Eq; Wed, 17 Mar 2021 13:27:42 -0500
Subject: Re: [Intel-wired-lan] [PATCH][next] ixgbe: Fix out-of-bounds warning
 in ixgbe_host_interface_command()
To:     Jann Horn <jannh@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, linux-hardening@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20210317064148.GA55123@embeddedor>
 <CAG48ez2RDqKwx=umOHjo_1mYyNQgzvcP=KOw1HgSo4Prs_VQDw@mail.gmail.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <3bd8d009-2ad2-c24d-5c34-5970c52502de@embeddedor.com>
Date:   Wed, 17 Mar 2021 12:27:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez2RDqKwx=umOHjo_1mYyNQgzvcP=KOw1HgSo4Prs_VQDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lMatS-001uWQ-Eq
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:58230
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jann,

Please, see my comments below...

On 3/17/21 12:11, Jann Horn wrote:
> On Wed, Mar 17, 2021 at 8:43 AM Gustavo A. R. Silva
> <gustavoars@kernel.org> wrote:
>> Fix the following out-of-bounds warning by replacing the one-element
>> array in an anonymous union with a pointer:
>>
>>   CC [M]  drivers/net/ethernet/intel/ixgbe/ixgbe_common.o
>> drivers/net/ethernet/intel/ixgbe/ixgbe_common.c: In function ‘ixgbe_host_interface_command’:
>> drivers/net/ethernet/intel/ixgbe/ixgbe_common.c:3729:13: warning: array subscript 1 is above array bounds of ‘u32[1]’ {aka ‘unsigned int[1]’} [-Warray-bounds]
>>  3729 |   bp->u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
>>       |   ~~~~~~~~~~^~~~
>> drivers/net/ethernet/intel/ixgbe/ixgbe_common.c:3682:7: note: while referencing ‘u32arr’
>>  3682 |   u32 u32arr[1];
>>       |       ^~~~~~
>>
>> This helps with the ongoing efforts to globally enable -Warray-bounds.
>>
>> Notice that, the usual approach to fix these sorts of issues is to
>> replace the one-element array with a flexible-array member. However,
>> flexible arrays should not be used in unions. That, together with the
>> fact that the array notation is not being affected in any ways, is why
>> the pointer approach was chosen in this case.
>>
>> Link: https://github.com/KSPP/linux/issues/109
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>>  drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
>> index 62ddb452f862..bff3dc1af702 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
>> @@ -3679,7 +3679,7 @@ s32 ixgbe_host_interface_command(struct ixgbe_hw *hw, void *buffer,
>>         u32 hdr_size = sizeof(struct ixgbe_hic_hdr);
>>         union {
>>                 struct ixgbe_hic_hdr hdr;
>> -               u32 u32arr[1];
>> +               u32 *u32arr;
>>         } *bp = buffer;
>>         u16 buf_len, dword_len;
>>         s32 status;
> 
> This looks bogus. An array is inline, a pointer points elsewhere -
> they're not interchangeable.

Yep; but in this case these are the only places in the code where _u32arr_ is
being used:

3707         /* first pull in the header so we know the buffer length */
3708         for (bi = 0; bi < dword_len; bi++) {
3709                 bp->u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
3710                 le32_to_cpus(&bp->u32arr[bi]);
3711         }

3727         /* Pull in the rest of the buffer (bi is where we left off) */
3728         for (; bi <= dword_len; bi++) {
3729                 bp->u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
3730                 le32_to_cpus(&bp->u32arr[bi]);
3731         }

I think it is safe to turn _u32arra_ into a pointer and continue using the array notation
in this particular case.

I also mention this in the changelog text:

"Notice that, the usual approach to fix these sorts of issues is to
replace the one-element array with a flexible-array member. However,
flexible arrays should not be used in unions. That, together with the
fact that the array notation is not being affected in any ways, is why
the pointer approach was chosen in this case."

Do you see any particular problem with this in the current code?

Another solution for this would be as follows:

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
index 62ddb452f862..3ad95281d790 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -3677,10 +3677,11 @@ s32 ixgbe_host_interface_command(struct ixgbe_hw *hw, void *buffer,
                                 bool return_data)
 {
        u32 hdr_size = sizeof(struct ixgbe_hic_hdr);
-       union {
-               struct ixgbe_hic_hdr hdr;
-               u32 u32arr[1];
-       } *bp = buffer;
+       struct ixgbe_hic_hdr *bp_hdr = buffer;
+       struct {
+               size_t len;
+               u32 u32arr[];
+       } *bp;
        u16 buf_len, dword_len;
        s32 status;
        u32 bi;
@@ -3704,6 +3705,9 @@ s32 ixgbe_host_interface_command(struct ixgbe_hw *hw, void *buffer,
        /* Calculate length in DWORDs */
        dword_len = hdr_size >> 2;

+       bp = kmalloc(struct_size(bp, u32arr, dword_len), GFP_KERNEL);
+       bp->len = dword_len;
+       memcpy(bp->u32arr, buffer, flex_array_size(bp, u32arr, bp->len));
        /* first pull in the header so we know the buffer length */
        for (bi = 0; bi < dword_len; bi++) {
                bp->u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
@@ -3711,7 +3715,7 @@ s32 ixgbe_host_interface_command(struct ixgbe_hw *hw, void *buffer,
        }

        /* If there is any thing in data position pull it in */
-       buf_len = bp->hdr.buf_len;
+       buf_len = bp_hdr->buf_len;
        if (!buf_len)
                goto rel_out;

@@ -3724,6 +3728,9 @@ s32 ixgbe_host_interface_command(struct ixgbe_hw *hw, void *buffer,
        /* Calculate length in DWORDs, add 3 for odd lengths */
        dword_len = (buf_len + 3) >> 2;

+       bp = krealloc(bp, struct_size(bp, u32arr, dword_len), GFP_KERNEL);
+       bp->len = dword_len;
+       memcpy(&bp->u32arr[bi], ((u32 *)buffer + bi), flex_array_size(bp, u32arr, bp->len-bi));
        /* Pull in the rest of the buffer (bi is where we left off) */
        for (; bi <= dword_len; bi++) {
		^^^^^^
I just noticed it seems there is a bug right there. I think it should be bi < dword_len, instead

                bp->u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);


What do you guys think?

Thanks!
--
Gustavo


