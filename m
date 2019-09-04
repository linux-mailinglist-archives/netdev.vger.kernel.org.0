Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3A1DA7C63
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 09:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbfIDHOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 03:14:36 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44910 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728989AbfIDHOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 03:14:35 -0400
Received: by mail-pg1-f196.google.com with SMTP id i18so10714499pgl.11
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 00:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ptXADabb5n/Uc2U+JxU6XWhSfaCYrX4nW6MXQzcSgVU=;
        b=et6RQUdZnmf+z2LnHMhTNZZIXO4Ju+iojj0bqtf397lOXH2HgahlPkNHReVLaJPqLr
         x4o7B0pRJbdTG+3g+K/KfDIBaPE+Ln0Vz08SJQOGqsbuECoiDOB7BmwRxbL6No7t+/G4
         qplzyFza1CvtF2eR2DKy1cXdxcA24V6DZQgD977IqbbbofEmIWZ97A4+3pSD7nV1Baxs
         yWUkEPnHTxg5USCZVW/86hJg3LmgmyhZvFi7/UPVWXyhSFfMiyfLYdTLSs8+sILBbaJa
         WL94zmhLGTnQfqvOyz3LVw3uR1z/3jdTVOMswMnkNwtxbDbYt7Gi9SMWMwnSb9oFixYQ
         ueLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ptXADabb5n/Uc2U+JxU6XWhSfaCYrX4nW6MXQzcSgVU=;
        b=XQC+k2yJy5Qp2dO4/pDHxONxg8vuyCipJrIhYLaNdjQVj8j8Vsy+ppOGYK1X6zoLdz
         idpOMuYouWrH7By4QaT9uJk35QHDy5XLGf2q5BLz0/HKfudsQVJkyxv2JjBGMNvkFfg7
         jOZEa6e5xzWHsxf1XpwXCzT3XlM+Z5B6M3SA5kYCFW0FU+57vziE/izGOGXc1yL+0H3h
         N6Ek6FZHAdJz0pqii1Q2o74SOmOT7tlyCoK782+QE/2doE7YTneCXbxlQurPkgoU/3+d
         tuAxcHkgW9OQupYF66xSp+GRB7lMGUk4oRytCjmd+2bOCtSa4SNrrynfPHewuXwcO5cD
         VgBg==
X-Gm-Message-State: APjAAAVsxyz9iTGi3izcsIRB70N7r+Vu7sRfIK5rEElkjMzkjpp+Ecw1
        UbNDrWUocb66xJFNAGPBrF0=
X-Google-Smtp-Source: APXvYqz3D3+Agr8Y5us1E2JR7h+qlNtUmuMQN0DjEWRrYdTPnfGZUdEp4stopzEh98E/RG5rvWK7jQ==
X-Received: by 2002:a17:90a:a89:: with SMTP id 9mr3457541pjw.126.1567581275203;
        Wed, 04 Sep 2019 00:14:35 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id a186sm21769585pge.0.2019.09.04.00.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2019 00:14:34 -0700 (PDT)
Subject: Re: [Bridge] [PATCH v3 1/2] net: bridge: use mac_len in bridge
 forwarding
To:     Zahari Doychev <zahari.doychev@linux.com>
Cc:     netdev@vger.kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jiri@resnulli.us, nikolay@cumulusnetworks.com,
        simon.horman@netronome.com, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org, jhs@mojatatu.com,
        dsahern@gmail.com, xiyou.wangcong@gmail.com,
        johannes@sipsolutions.net, alexei.starovoitov@gmail.com
References: <20190902181000.25638-1-zahari.doychev@linux.com>
 <76b7723b-68dd-0efc-9a93-0597e9d9b827@gmail.com>
 <20190903133635.siw6xcaqwk7m5a5a@tycho>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <a9a093f2-1ec6-339c-b015-eb658618cf2b@gmail.com>
Date:   Wed, 4 Sep 2019 16:14:28 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190903133635.siw6xcaqwk7m5a5a@tycho>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/09/03 22:36, Zahari Doychev wrote:
> On Tue, Sep 03, 2019 at 08:37:36PM +0900, Toshiaki Makita wrote:
>> Hi Zahari,
>>
>> Sorry for reviewing this late.
>>
>> On 2019/09/03 3:09, Zahari Doychev wrote:
>> ...
>>> @@ -466,13 +466,14 @@ static bool __allowed_ingress(const struct net_bridge *br,
>>>    		/* Tagged frame */
>>>    		if (skb->vlan_proto != br->vlan_proto) {
>>>    			/* Protocol-mismatch, empty out vlan_tci for new tag */
>>> -			skb_push(skb, ETH_HLEN);
>>> +			skb_push(skb, skb->mac_len);
>>>    			skb = vlan_insert_tag_set_proto(skb, skb->vlan_proto,
>>>    							skb_vlan_tag_get(skb));
>>
>> I think we should insert vlan at skb->data, i.e. mac_header + mac_len, while this
>> function inserts the tag at mac_header + ETH_HLEN which is not always the correct
>> offset.
> 
> Maybe I am misunderstanding the concern here but this should make sure that
> the VLAN tag from the skb is move back in the payload as the outer most tag.
> So it should follow the ethernet header. It looks like this e.g.,:
> 
> VLAN1 in skb:
> +------+------+-------+
> | DMAC | SMAC | ETYPE |
> +------+------+-------+
> 
> VLAN1 moved to payload:
> +------+------+-------+-------+
> | DMAC | SMAC | VLAN1 | ETYPE |
> +------+------+-------+-------+
> 
> VLAN2 in skb:
> +------+------+-------+-------+
> | DMAC | SMAC | VLAN1 | ETYPE |
> +------+------+-------+-------+
> 
> VLAN2 moved to payload:
> 
> +------+------+-------+-------+
> | DMAC | SMAC | VLAN2 | VLAN1 | ....
> +------+------+-------+-------+
> 
> Doing the skb push with mac_len makes sure that VLAN tag is inserted in the
> correct offset. For mac_len == ETH_HLEN this does not change the current
> behaviour.

Reordering VLAN headers here does not look correct to me. If skb->data points to ETH+VLAN,
then we should insert the vlan at the offset.
Vlan devices with reorder_hdr disabled produce packets whose mac_len includes ETH+VLAN header,
and they expects vlan insertion after the outer vlan header.

Also I'm not sure there is standard ethernet header in mac_len, as mac_len is not ETH_HLEN.
E.g. tun devices can produce vlan packets without ehternet header.

> 
>>
>>>    			if (unlikely(!skb))
>>>    				return false;
>>>    			skb_pull(skb, ETH_HLEN);
>>
>> Now skb->data is mac_header + ETH_HLEN which would be broken when mac_len is not
>> ETH_HLEN?
> 
> I thought it would be better to point in this case to the outer tag as otherwise
> if mac_len is used the skb->data will point to the next tag which I find somehow
> inconsistent or do you see some case where this can cause problems?

Vlan devices with reorder_hdr off will break because it relies on skb->data offset
as I described in the previous discussion.

Toshiaki Makita
