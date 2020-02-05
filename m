Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDDA15281E
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 10:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgBEJT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 04:19:29 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39272 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728034AbgBEJT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 04:19:28 -0500
Received: by mail-pj1-f65.google.com with SMTP id e9so729480pjr.4;
        Wed, 05 Feb 2020 01:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wKml5djSVHQcmNXNztVosBS8cCxU3q15aBmfCqyr090=;
        b=rZdRbaJ7Czt5T22V2HaWsif2Ka26eaY3Z9GG3ccBwzAxA+FUtXbqzMO47XGPKPFAbt
         Iva/pKq/Rbaq4mXgMAXg+6SBzCtX+e6yTCuuJixco+ojdq7FDCiR+WyQHtF3GkCCSMAe
         faviYmhEr66/W8aKOa93Wvfa4wTKRzoqGx59GyB83CdoNT9Se2vWQc/iZq5dOutEUlCc
         n82TWnpTBB/O4JZvRCPw27vFZG0z92YwqNrOdnto+LvvHOkuJYeuU7dHS1pj1NbIJTPr
         SL2m2cHJZBr2Ko9xkHoqU6Cp4mV4EuBZwfgm5e8GQGdPvoEhGIWiIAupH2IIplLPuN7z
         zCVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wKml5djSVHQcmNXNztVosBS8cCxU3q15aBmfCqyr090=;
        b=rWmKP9i7bmh39ZAezeElTDfJ1cgIZfqeDbCRghjzeP3ZxLo/num6RcNTJiM0OkolE8
         feWtxjh3GTnzqt/KsWNv7XK90vrYi4/vadzRn6ScVC07vCFr46baXM7o0qR9c9g/okxt
         mmxGTYxfF+wXJkudAR+V8VFG9RwyhU+ioVV/2dL/Uz9GbfeFZY2GeznbkBrqdtNy3Ef6
         8SKUiXCa5vimB/Qmtxl2BEFNhT696TrFnUL78PSEjN0n5oBkbJ3JXrCYjsGUQFkvdMj3
         AV+rNukYdcrreGOuFmFgWcpa5q7lmw/LwhqnekzAj4ND4yTJgEHF6vFhsfwvhab65G6y
         aYEw==
X-Gm-Message-State: APjAAAVDXdCE4Nlf9/XII7NIAH2bNC6C4db3giyekVOTawxXXU9uztty
        1Pcj1tiETf0Om24TeDkjH5A7AN8QB/Fiaw==
X-Google-Smtp-Source: APXvYqyMQnco7HBn74QT87oektAi3nGlKI5OQE2tSHNwbCsvMd72tiGtmtqNwr3iUaPFie6a7QdBAQ==
X-Received: by 2002:a17:90a:2808:: with SMTP id e8mr4494736pjd.63.1580894367536;
        Wed, 05 Feb 2020 01:19:27 -0800 (PST)
Received: from [192.168.100.27] ([103.202.217.14])
        by smtp.gmail.com with ESMTPSA id b1sm28340059pfg.182.2020.02.05.01.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 01:19:27 -0800 (PST)
Subject: Re: [PATCH bpf-next v4] virtio_net: add XDP meta data support
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, kuba@kernel.org,
        andriin@fb.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <8da1b560-3128-b885-b453-13de5c7431fb@redhat.com>
 <20200204071655.94474-1-yuya.kusakabe@gmail.com>
 <20200205003236-mutt-send-email-mst@kernel.org>
From:   Yuya Kusakabe <yuya.kusakabe@gmail.com>
Autocrypt: addr=yuya.kusakabe@gmail.com; keydata=
 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 V13X
Message-ID: <e45cce1f-d3b0-ddc4-0f97-103b91f8c81e@gmail.com>
Date:   Wed, 5 Feb 2020 18:19:21 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200205003236-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/5/20 2:33 PM, Michael S. Tsirkin wrote:
> On Tue, Feb 04, 2020 at 04:16:55PM +0900, Yuya Kusakabe wrote:
>> @@ -852,8 +868,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>  			 * adjustments. Note other cases do not build an
>>  			 * skb and avoid using offset
>>  			 */
>> -			offset = xdp.data -
>> -					page_address(xdp_page) - vi->hdr_len;
>> +			metasize = xdp.data - xdp.data_meta;
>> +			offset = xdp.data - page_address(xdp_page) -
>> +				 vi->hdr_len - metasize;
>>  
>>  			/* recalculate len if xdp.data or xdp.data_end were
>>  			 * adjusted
> 
> Tricky to get one's head around.
> Can you pls update the comment above to document the new math?
> 

Thank you for your review.

I will update the comment on next patch.
