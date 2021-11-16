Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A595452A12
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 06:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238177AbhKPFzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 00:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238014AbhKPFy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 00:54:59 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E207C0AD840;
        Mon, 15 Nov 2021 21:02:54 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id 1so40524768ljv.2;
        Mon, 15 Nov 2021 21:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=33rumaWr9qlBk+pQo3yKk/+p7rzkpn3TeXUIKcpGn90=;
        b=ZZcnmPT6yr1WWiYgp3t9VKZYYUeqJRqwj68snZsmqMJT8TQwx1VuCQm0iZb3MPMIPF
         vwjDjthny4ctrdpHlKOC7Dyu2hyJmvTDzc8uH/t/z7yFAvMvavdiE8NNTuWPlwi+bK08
         3Vu/5T5D7FKry3UZDL4oZJw0adBtq1U7KUD3AwVQgH7jvDKlFe7xzbRpTZ2hg/tbwlp+
         dBtAXjSSSzg67LDcqePVi8MQgKVbIYwhIWtyAP0uhSHzR4ug8PQAuUi0zETD0FTKCSWP
         CXA8IuvPmicuHCxh3+OQhP98MrVzawxMsdPsrHz4wI3AW+a15S2v0l6kttQ1T5neag2C
         CqEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=33rumaWr9qlBk+pQo3yKk/+p7rzkpn3TeXUIKcpGn90=;
        b=RcGK25HkAX0EN+TJpUQ+mwPWEI7eE1QttEvCy5rVoJJ2i7s9QmCCQt/tjoNbNVIyPf
         HfkkOmRUgorc/3rbNHNDP9/0U7RuXhCZcxMIVpsTa2sa/5xGFnEI8Aw9ibljdTbsBjaG
         09qbHWY10YK920Z73AWc5mPd6u2zvNzmnccBXBf5R7W5OnJbsysNmyTvLcl7Wa21MADm
         a2LKC5toFs7sXZe1ysjlvVxJZ2UtEZ7S92M+ZnAx4IRKG8HJ8bgJqvFM23/XF6rkt0kv
         anoiznubQnPXJ1LhOx3kv0wjTyVFH6vbeseypCC/kTTYuG4FE8yfPPq463kHP3Mdh4n1
         F1hw==
X-Gm-Message-State: AOAM532H87RkPWXY883ncwmoSVl5P5gBjVb1VyOP+On2XCDLixgug2kN
        pzXcVHiq3Ja3LOpNUrYXNG0PKMy41bk=
X-Google-Smtp-Source: ABdhPJwn9PgAvM9s7iicfRfP1tRs6kfQFtDJqhWAwv+au+FNtXm533o1AnM4aVEVobt12OKxQCSQIw==
X-Received: by 2002:a2e:bf12:: with SMTP id c18mr4312498ljr.462.1637038972312;
        Mon, 15 Nov 2021 21:02:52 -0800 (PST)
Received: from [172.28.2.233] ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id y28sm1634285lfa.92.2021.11.15.21.02.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 21:02:51 -0800 (PST)
Message-ID: <afe5d0f0-f02f-e970-cc16-6cbe2b2dd971@gmail.com>
Date:   Tue, 16 Nov 2021 08:02:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] Bluetooth: stop proccessing malicious adv data
Content-Language: en-US
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+e3fcb9c4f3c2a931dc40@syzkaller.appspotmail.com
References: <20211101071212.15355-1-paskripkin@gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20211101071212.15355-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 10:12, Pavel Skripkin wrote:
> Syzbot reported slab-out-of-bounds read in hci_le_adv_report_evt(). The
> problem was in missing validaion check.
> 
> We should check if data is not malicious and we can read next data block.
> If we won't check ptr validness, code can read a way beyond skb->end and
> it can cause problems, of course.
> 
> Fixes: e95beb414168 ("Bluetooth: hci_le_adv_report_evt code refactoring")
> Reported-and-tested-by: syzbot+e3fcb9c4f3c2a931dc40@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---

Hi, Bluetooth maintainers!

friendly ping :)


If anything is wrong with this one, please, let me know


With regards,
Pavel Skripkin


>   net/bluetooth/hci_event.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 0bca035bf2dc..50d1d62c15ec 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -5780,7 +5780,8 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
>   		struct hci_ev_le_advertising_info *ev = ptr;
>   		s8 rssi;
>   
> -		if (ev->length <= HCI_MAX_AD_LENGTH) {
> +		if (ev->length <= HCI_MAX_AD_LENGTH &&
> +		    ev->data + ev->length <= skb_tail_pointer(skb)) {
>   			rssi = ev->data[ev->length];
>   			process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
>   					   ev->bdaddr_type, NULL, 0, rssi,
> @@ -5790,6 +5791,11 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
>   		}
>   
>   		ptr += sizeof(*ev) + ev->length + 1;
> +
> +		if (ptr > (void *) skb_tail_pointer(skb) - sizeof(*ev)) {
> +			bt_dev_err(hdev, "Malicious advertising data. Stopping processing");
> +			break;
> +		}
>   	}
>   
>   	hci_dev_unlock(hdev);
> 


