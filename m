Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F288D1514A5
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 04:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgBDDb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 22:31:59 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21865 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726924AbgBDDb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 22:31:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580787117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cax2vg6hCpK83ziSdtZRyV/IuEOISy/0pGTiP8tUlOQ=;
        b=V7UgJaaE+Qq2lV3ICfV3XRBXk/sAI9qR0yTqBDmip1Bmg7Mn9ecRpR9U7hbGqmijvn7NUH
        YQPaf+UmGL4Aw4P67Q6F8W10RHl8nJiZEXoq0QhzgzeXRbfwJWpQAKU1iNss7Vuu/tfazu
        LglFKkY7dXMELkSvSnUQBUzRwKMbyU0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-Mu5RxpzpMEWT4X6J3RfhMQ-1; Mon, 03 Feb 2020 22:31:51 -0500
X-MC-Unique: Mu5RxpzpMEWT4X6J3RfhMQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F094800D5B;
        Tue,  4 Feb 2020 03:31:49 +0000 (UTC)
Received: from [10.72.12.170] (ovpn-12-170.pek2.redhat.com [10.72.12.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A75686458;
        Tue,  4 Feb 2020 03:31:40 +0000 (UTC)
Subject: Re: [PATCH bpf-next v3] virtio_net: add XDP meta data support
To:     Yuya Kusakabe <yuya.kusakabe@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
References: <32dc2f4e-4f19-4fa5-1d24-17a025a08297@gmail.com>
 <20190702081646.23230-1-yuya.kusakabe@gmail.com>
 <ca724dcf-4ffb-ff49-d307-1b45143712b5@redhat.com>
 <52e3fc0d-bdd7-83ee-58e6-488e2b91cc83@gmail.com>
 <a5f4601a-db0e-e65b-5b32-cc7e04ba90be@iogearbox.net>
 <eb955137-11d5-13b2-683a-6a2e8425d792@redhat.com>
 <116cdb35-57b3-e2fe-ef8a-05cc6a1afbbe@iogearbox.net>
 <eaa707f1-9058-97dc-db57-99746f9464fd@redhat.com>
 <CAGCJULNe_2tQRrSdO3BPS5_qvNnqgyU=33hFcVe8Tnxfzy57fA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8da1b560-3128-b885-b453-13de5c7431fb@redhat.com>
Date:   Tue, 4 Feb 2020 11:31:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGCJULNe_2tQRrSdO3BPS5_qvNnqgyU=33hFcVe8Tnxfzy57fA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/3 =E4=B8=8B=E5=8D=889:52, Yuya Kusakabe wrote:
> I'm sorry for the late reply.
>
> I saw the status of this patch is "Awaiting Upstream" on
> https://patchwork.ozlabs.org/patch/1126046/. What is "Awaiting
> Upstream"? Is there anything that I can do?


You can post a new version I think.

Thanks


>
> Thank you,
> Yuya
>
> On Wed, Jul 10, 2019 at 11:30 AM Jason Wang <jasowang@redhat.com> wrote=
:
>>
>> On 2019/7/10 =E4=B8=8A=E5=8D=884:03, Daniel Borkmann wrote:
>>> On 07/09/2019 05:04 AM, Jason Wang wrote:
>>>> On 2019/7/9 =E4=B8=8A=E5=8D=886:38, Daniel Borkmann wrote:
>>>>> On 07/02/2019 04:11 PM, Yuya Kusakabe wrote:
>>>>>> On 7/2/19 5:33 PM, Jason Wang wrote:
>>>>>>> On 2019/7/2 =E4=B8=8B=E5=8D=884:16, Yuya Kusakabe wrote:
>>>>>>>> This adds XDP meta data support to both receive_small() and
>>>>>>>> receive_mergeable().
>>>>>>>>
>>>>>>>> Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
>>>>>>>> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
>>>>>>>> ---
>>>>>>>> v3:
>>>>>>>>      - fix preserve the vnet header in receive_small().
>>>>>>>> v2:
>>>>>>>>      - keep copy untouched in page_to_skb().
>>>>>>>>      - preserve the vnet header in receive_small().
>>>>>>>>      - fix indentation.
>>>>>>>> ---
>>>>>>>>      drivers/net/virtio_net.c | 45 +++++++++++++++++++++++++++--=
-----------
>>>>>>>>      1 file changed, 31 insertions(+), 14 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>>>>>> index 4f3de0ac8b0b..03a1ae6fe267 100644
>>>>>>>> --- a/drivers/net/virtio_net.c
>>>>>>>> +++ b/drivers/net/virtio_net.c
>>>>>>>> @@ -371,7 +371,7 @@ static struct sk_buff *page_to_skb(struct vi=
rtnet_info *vi,
>>>>>>>>                         struct receive_queue *rq,
>>>>>>>>                         struct page *page, unsigned int offset,
>>>>>>>>                         unsigned int len, unsigned int truesize,
>>>>>>>> -                   bool hdr_valid)
>>>>>>>> +                   bool hdr_valid, unsigned int metasize)
>>>>>>>>      {
>>>>>>>>          struct sk_buff *skb;
>>>>>>>>          struct virtio_net_hdr_mrg_rxbuf *hdr;
>>>>>>>> @@ -393,7 +393,7 @@ static struct sk_buff *page_to_skb(struct vi=
rtnet_info *vi,
>>>>>>>>          else
>>>>>>>>              hdr_padded_len =3D sizeof(struct padded_vnet_hdr);
>>>>>>>>      -    if (hdr_valid)
>>>>>>>> +    if (hdr_valid && !metasize)
>>>>>>>>              memcpy(hdr, p, hdr_len);
>>>>>>>>            len -=3D hdr_len;
>>>>>>>> @@ -405,6 +405,11 @@ static struct sk_buff *page_to_skb(struct v=
irtnet_info *vi,
>>>>>>>>              copy =3D skb_tailroom(skb);
>>>>>>>>          skb_put_data(skb, p, copy);
>>>>>>>>      +    if (metasize) {
>>>>>>>> +        __skb_pull(skb, metasize);
>>>>>>>> +        skb_metadata_set(skb, metasize);
>>>>>>>> +    }
>>>>>>>> +
>>>>>>>>          len -=3D copy;
>>>>>>>>          offset +=3D copy;
>>>>>>>>      @@ -644,6 +649,7 @@ static struct sk_buff *receive_small(st=
ruct net_device *dev,
>>>>>>>>          unsigned int delta =3D 0;
>>>>>>>>          struct page *xdp_page;
>>>>>>>>          int err;
>>>>>>>> +    unsigned int metasize =3D 0;
>>>>>>>>            len -=3D vi->hdr_len;
>>>>>>>>          stats->bytes +=3D len;
>>>>>>>> @@ -683,10 +689,13 @@ static struct sk_buff *receive_small(struc=
t net_device *dev,
>>>>>>>>                xdp.data_hard_start =3D buf + VIRTNET_RX_PAD + vi=
->hdr_len;
>>>>>>>>              xdp.data =3D xdp.data_hard_start + xdp_headroom;
>>>>>>>> -        xdp_set_data_meta_invalid(&xdp);
>>>>>>>>              xdp.data_end =3D xdp.data + len;
>>>>>>>> +        xdp.data_meta =3D xdp.data;
>>>>>>>>              xdp.rxq =3D &rq->xdp_rxq;
>>>>>>>>              orig_data =3D xdp.data;
>>>>>>>> +        /* Copy the vnet header to the front of data_hard_start=
 to avoid
>>>>>>>> +         * overwriting by XDP meta data */
>>>>>>>> +        memcpy(xdp.data_hard_start - vi->hdr_len, xdp.data - vi=
->hdr_len, vi->hdr_len);
>>>>> I'm not fully sure if I'm following this one correctly, probably ju=
st missing
>>>>> something. Isn't the vnet header based on how we set up xdp.data_ha=
rd_start
>>>>> earlier already in front of it? Wouldn't we copy invalid data from =
xdp.data -
>>>>> vi->hdr_len into the vnet header at that point (given there can be =
up to 256
>>>>> bytes of headroom between the two)? If it's relative to xdp.data an=
d headroom
>>>>> is >0, then BPF prog could otherwise mangle this; something doesn't=
 add up to
>>>>> me here. Could you clarify? Thx
>>>> Vnet headr sits just in front of xdp.data not xdp.data_hard_start. S=
o it could be overwrote by metadata, that's why we need a copy here.
>>> For the current code, you can adjust the xdp.data with a positive/neg=
ative offset
>>> already via bpf_xdp_adjust_head() helper. If vnet headr sits just in =
front of
>>> xdp.data, couldn't this be overridden today as well then? Anyway, jus=
t wondering
>>> how this is handled differently?
>>
>> We will invalidate the vnet header in this case. But for the case of
>> metadata adjustment without header adjustment, we want to seek a way t=
o
>> preserve that.
>>
>> Thanks
>>
>>
>>> Thanks,
>>> Daniel
>
>

