Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F912614D8
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 18:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732057AbgIHQiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 12:38:51 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:35560 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731159AbgIHQib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:38:31 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 088GcK6r101294;
        Tue, 8 Sep 2020 11:38:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599583100;
        bh=Zy3z+/BHoA+oz6zF/b9ei0+HV/TBYphaUikRkWL2/KA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=AFuz8Am3r+6XqaywOgD/QkP3/RGOPnYKfEgLMWcpyf8yCGS/ev3l4FmYhAb5SLxa7
         /M0lO+YcyulTQ4SYbby/bS5M+B4y8Nxi/TRdXO1nYV4x6pIq8nyiLfesoLThIX7/oS
         2uwsuGbqbtKF3d7ct4MD+f5xERh90YxGQ4USCJ+E=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 088GcKYl016657
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 8 Sep 2020 11:38:20 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 8 Sep
 2020 11:38:20 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 8 Sep 2020 11:38:20 -0500
Received: from [10.250.53.226] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 088GcJUT113732;
        Tue, 8 Sep 2020 11:38:19 -0500
Subject: Re: [PATCH net-next 1/1] net: hsr/prp: add vlan support
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
References: <20200901195415.4840-1-m-karicheri2@ti.com>
 <20200901195415.4840-2-m-karicheri2@ti.com>
 <CA+FuTScPZ5sfHBwbFKQza6w4G1UcO8DaqrcpFuSvr9svgMEepw@mail.gmail.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <581a90d0-243e-f62e-1c2e-a9683807805c@ti.com>
Date:   Tue, 8 Sep 2020 12:38:14 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTScPZ5sfHBwbFKQza6w4G1UcO8DaqrcpFuSvr9svgMEepw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

Thanks for the response!
On 9/4/20 11:45 AM, Willem de Bruijn wrote:
> On Tue, Sep 1, 2020 at 9:54 PM Murali Karicheri <m-karicheri2@ti.com> wrote:
>>
>> This patch add support for creating vlan interfaces
>> over hsr/prp interface.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> ---
>>   net/hsr/hsr_device.c  |  4 ----
>>   net/hsr/hsr_forward.c | 16 +++++++++++++---
>>   2 files changed, 13 insertions(+), 7 deletions(-)
>>
>> diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
>> index ab953a1a0d6c..e1951579a3ad 100644
>> --- a/net/hsr/hsr_device.c
>> +++ b/net/hsr/hsr_device.c
>> @@ -477,10 +477,6 @@ void hsr_dev_setup(struct net_device *dev)
>>
>>          /* Prevent recursive tx locking */
>>          dev->features |= NETIF_F_LLTX;
>> -       /* VLAN on top of HSR needs testing and probably some work on
>> -        * hsr_header_create() etc.
>> -        */
>> -       dev->features |= NETIF_F_VLAN_CHALLENGED;
>>          /* Not sure about this. Taken from bridge code. netdev_features.h says
>>           * it means "Does not change network namespaces".
>>           */
>> diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
>> index cadfccd7876e..de21df30b0d9 100644
>> --- a/net/hsr/hsr_forward.c
>> +++ b/net/hsr/hsr_forward.c
>> @@ -208,6 +208,7 @@ static struct sk_buff *hsr_fill_tag(struct sk_buff *skb,
>>                                      struct hsr_port *port, u8 proto_version)
>>   {
>>          struct hsr_ethhdr *hsr_ethhdr;
>> +       unsigned char *pc;
>>          int lsdu_size;
>>
>>          /* pad to minimum packet size which is 60 + 6 (HSR tag) */
>> @@ -218,7 +219,18 @@ static struct sk_buff *hsr_fill_tag(struct sk_buff *skb,
>>          if (frame->is_vlan)
>>                  lsdu_size -= 4;
>>
>> -       hsr_ethhdr = (struct hsr_ethhdr *)skb_mac_header(skb);
>> +       pc = skb_mac_header(skb);
>> +       if (frame->is_vlan)
>> +               /* This 4-byte shift (size of a vlan tag) does not
>> +                * mean that the ethhdr starts there. But rather it
>> +                * provides the proper environment for accessing
>> +                * the fields, such as hsr_tag etc., just like
>> +                * when the vlan tag is not there. This is because
>> +                * the hsr tag is after the vlan tag.
>> +                */
>> +               hsr_ethhdr = (struct hsr_ethhdr *)(pc + VLAN_HLEN);
>> +       else
>> +               hsr_ethhdr = (struct hsr_ethhdr *)pc;
> 
> Instead, I would pass the header from the caller, which knows the
> offset because it moves the previous headers to make space.
> 
So if I understood you correctly a diff for the above would like this
where pass dst + movelen as  struct hsr_ethhdr *hsr_ethhdr
pointer to hsr_fill_tag(), right?

a0868495local@uda0868495:~/Projects/upstream-kernel$ git diff
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index de21df30b0d9..4d9192c8bcf8 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -204,11 +204,10 @@ static void hsr_set_path_id(struct hsr_ethhdr 
*hsr_ethhdr,
  }

  static struct sk_buff *hsr_fill_tag(struct sk_buff *skb,
+                                   struct hsr_ethhdr *hsr_ethhdr,
                                     struct hsr_frame_info *frame,
                                     struct hsr_port *port, u8 
proto_version)
  {
-       struct hsr_ethhdr *hsr_ethhdr;
-       unsigned char *pc;
         int lsdu_size;

         /* pad to minimum packet size which is 60 + 6 (HSR tag) */
@@ -219,19 +218,6 @@ static struct sk_buff *hsr_fill_tag(struct sk_buff 
*skb,
         if (frame->is_vlan)
                 lsdu_size -= 4;

-       pc = skb_mac_header(skb);
-       if (frame->is_vlan)
-               /* This 4-byte shift (size of a vlan tag) does not
-                * mean that the ethhdr starts there. But rather it
-                * provides the proper environment for accessing
-                * the fields, such as hsr_tag etc., just like
-                * when the vlan tag is not there. This is because
-                * the hsr tag is after the vlan tag.
-                */
-               hsr_ethhdr = (struct hsr_ethhdr *)(pc + VLAN_HLEN);
-       else
-               hsr_ethhdr = (struct hsr_ethhdr *)pc;
-
         hsr_set_path_id(hsr_ethhdr, port);
         set_hsr_tag_LSDU_size(&hsr_ethhdr->hsr_tag, lsdu_size);
         hsr_ethhdr->hsr_tag.sequence_nr = htons(frame->sequence_nr);
@@ -280,10 +266,12 @@ struct sk_buff *hsr_create_tagged_frame(struct 
hsr_frame_info *frame,
         memmove(dst, src, movelen);
         skb_reset_mac_header(skb);

-       /* skb_put_padto free skb on error and hsr_fill_tag returns NULL in
-        * that case
+       /* dst point to the start of hsr tag. So pass it to fill the
+        * hsr info. Also skb_put_padto free skb on error and hsr_fill_tag
+        * returns NULL in that case.
          */
-       return hsr_fill_tag(skb, frame, port, port->hsr->prot_version);
+       return hsr_fill_tag(skb, (struct hsr_ethhdr *)(dst + movelen),
+                           frame, port, port->hsr->prot_version);
  }


> Also, supporting VLAN probably also requires supporting 802.1ad QinQ,
> which means code should parse the headers instead of hardcoding
> VLAN_HLEN.
> 

iec-62439-3 standard only talks about VLAN (TPID 0x8100), not about
QinQ. So what I could do is to check and bail out if 802.1ad frame is
received at the interface from upper layer. Something like below and
frame will get dropped.

@@ -519,6 +507,8 @@ static int fill_frame_info(struct hsr_frame_info *frame,

         if (proto == htons(ETH_P_8021Q))
                 frame->is_vlan = true;
+       else if (proto == htons(ETH_P_8021AD))
+               return -1; /* Don't support 802.1ad */

         if (frame->is_vlan) {
                 vlan_hdr = (struct hsr_vlan_ethhdr *)ethhdr;

What do you think?

Thanks.
>>          hsr_set_path_id(hsr_ethhdr, port);
>>          set_hsr_tag_LSDU_size(&hsr_ethhdr->hsr_tag, lsdu_size);
>> @@ -511,8 +523,6 @@ static int fill_frame_info(struct hsr_frame_info *frame,
>>          if (frame->is_vlan) {
>>                  vlan_hdr = (struct hsr_vlan_ethhdr *)ethhdr;
>>                  proto = vlan_hdr->vlanhdr.h_vlan_encapsulated_proto;
>> -               /* FIXME: */
>> -               netdev_warn_once(skb->dev, "VLAN not yet supported");
>>          }
>>
>>          frame->is_from_san = false;
>> --
>> 2.17.1
>>

-- 
Murali Karicheri
Texas Instruments
