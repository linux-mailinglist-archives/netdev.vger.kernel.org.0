Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B91262B6E5
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 10:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbiKPJtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 04:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233684AbiKPJte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 04:49:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884082673
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 01:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668592116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KEr65FftyAvd0R6Y1Vvx/V9RSQkCwNJYF7Ig4eQxDek=;
        b=iOJnvYO20iSHCCEAVB9dSyyKWCEnNyqns0XPBKC8vYWE1wVVpZvkugHHqITV4Wj9PikApC
        rhWirrPbY/rupDSzGeAeREmB8eThhaNXk9Ke7hCeGqNWIzijMz78rJs984seIMVUazgaHR
        lqSoglV6WtnBuyy8DLMN37jns2DDHF8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-594-Td38MzKqOHuJ1S23-DwbUA-1; Wed, 16 Nov 2022 04:48:35 -0500
X-MC-Unique: Td38MzKqOHuJ1S23-DwbUA-1
Received: by mail-ej1-f71.google.com with SMTP id ne36-20020a1709077ba400b007aeaf3dcbcaso8846503ejc.6
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 01:48:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KEr65FftyAvd0R6Y1Vvx/V9RSQkCwNJYF7Ig4eQxDek=;
        b=qVVSgr2x9p9K24BeSJ8MIB/4uiYGpeMbxXN1CZfQ1GfePEUbAr1qZaW8hhKu6VsofI
         kqaGNmjwhhIo4zzbs8XJA6FAKpwQpQ0WXjz1eLkH9ImKaLyIy3KcuStXdoCDe06IDdwj
         dJh3NuNHWuZnQZFZLlzoW8vfNDjS/zYDP5mYwDV0z+R2Ose/z99uODqcb0qlWKmndzI4
         Sh3MCne3aHa3v1mPqN/EagkV+u6jDZLiisyYJ3IvaL2I4d9Khn9Kq8m5LXkUVw8hcmps
         6fb8cQtZpwiy15joq7gLgwJ+HdbAl6cMXHPIWRY2Hq0NplURUhw1HJ215wCwgDe9VeuH
         iJAg==
X-Gm-Message-State: ANoB5plIHWmrRAoy8BR6jm7Gu9XB5wYFjHrUnhv2acSzku7Mt7dxWE3Y
        3aZe4n3ewyInf5V5drlCOsOdkD2pkGyZtcGwo7NmEUf/PtTu6eW+c2d3xcPQGsrS+aMsVIFHdNC
        4kYfZ5Jw8Zf2ynYQ0
X-Received: by 2002:a17:906:c259:b0:7ae:df97:a033 with SMTP id bl25-20020a170906c25900b007aedf97a033mr14489507ejb.344.1668592113190;
        Wed, 16 Nov 2022 01:48:33 -0800 (PST)
X-Google-Smtp-Source: AA0mqf46f5R98rWOiuVMfxT5H9JqDg0AMWcLplaALtHZKqoGKNlX4UvAtiJsthbmVSFbclKGQv1LDg==
X-Received: by 2002:a17:906:c259:b0:7ae:df97:a033 with SMTP id bl25-20020a170906c25900b007aedf97a033mr14489439ejb.344.1668592111657;
        Wed, 16 Nov 2022 01:48:31 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t23-20020aa7d717000000b0046800749670sm3369927edq.53.2022.11.16.01.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 01:48:31 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2F5407A6DDA; Wed, 16 Nov 2022 10:48:30 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 06/11] xdp: Carry over xdp
 metadata into skb context
In-Reply-To: <fd21dfd5-f458-dfba-594d-3aafd6a4648a@linux.dev>
References: <20221115030210.3159213-1-sdf@google.com>
 <20221115030210.3159213-7-sdf@google.com>
 <fd21dfd5-f458-dfba-594d-3aafd6a4648a@linux.dev>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 16 Nov 2022 10:48:30 +0100
Message-ID: <87bkp7jklt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <martin.lau@linux.dev> writes:

> On 11/14/22 7:02 PM, Stanislav Fomichev wrote:
>> Implement new bpf_xdp_metadata_export_to_skb kfunc which
>> prepares compatible xdp metadata for kernel consumption.
>> This kfunc should be called prior to bpf_redirect
>> or when XDP_PASS'ing the frame into the kernel (note, the drivers
>> have to be updated to enable consuming XDP_PASS'ed metadata).
>> 
>> veth driver is amended to consume this metadata when converting to skb.
>> 
>> Internally, XDP_FLAGS_HAS_SKB_METADATA flag is used to indicate
>> whether the frame has skb metadata. The metadata is currently
>> stored prior to xdp->data_meta. bpf_xdp_adjust_meta refuses
>> to work after a call to bpf_xdp_metadata_export_to_skb (can lift
>> this requirement later on if needed, we'd have to memmove
>> xdp_skb_metadata).
>
> It is ok to refuse bpf_xdp_adjust_meta() after bpf_xdp_metadata_export_to_skb() 
> for now.  However, it will also need to refuse bpf_xdp_adjust_head().

I'm also OK with deferring this, although I'm wondering if it isn't just
as easy to just add the memmove() straight away? :)

-Toke

