Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE224421625
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 20:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237847AbhJDSN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 14:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbhJDSN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 14:13:58 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC85C061745;
        Mon,  4 Oct 2021 11:12:09 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id 73so17380663qki.4;
        Mon, 04 Oct 2021 11:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+fT+aA8O5oRqS8Fx8O+K4w9xvhEfwcMTbFUqJDULxaY=;
        b=cB8begJI5ATh6WUeF3PsZL0eN0zkI5dsdFYEZsxDXbahwFjHCE1LT8VFlsj9Lzs7/j
         Jmu/pnTyPj5S+Fm/F9qYXTzyt8PT95g2kYwLN9j+Tyu+yiMElJlKLkLaso0lI5fd8zOQ
         8aikJdx6bbwK0b4VlPhSQGhg3iUjzqBBi0LBltW4vu8eeDkG4nF6JyhWEyPQbE4QM4x6
         e5iIa+gy3aim9dxo2/Lhxkkdm/9LBYhyL/YErgBSFkwgRcBPqEnGsPjCkdX4bTXXD6Am
         uXRC8r/AvgiBFtEY8N7CPtTQmEtAR6muZNgeF1XFRg1hGD1UHOSUVA5Wk6j3ANGQ+glD
         RaIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+fT+aA8O5oRqS8Fx8O+K4w9xvhEfwcMTbFUqJDULxaY=;
        b=5fLsraFjhG1lwxIgZiT6OMdPZuSsZFMG6V9Fpvss3WHUzx1MkW0IAIV1njH8q5w+wW
         h7kA1gtKm8nKS3R3Oxrluqpeg+2ixEc/mf1HDRirpf2DPHo6o/NPczJmkWhxn5OOAA0o
         LgntKCnhtLyVX/fswc229A6aC3NvMSWJjmb0pxS2hl5c8O5IsH15dzkVOdZKewEj46WM
         BfjDrZ2i3Y0gRl7xee7QYEY/zGDlBNtsCyPNX8wsFxA7sqqYuQMAPK9W/M3KgAv9+GXR
         Ef2yNm8FuBtYAp3i05joTY+4+ROBjMxf4xuN64uTlw9Bi3wsmuzF9VrVsF4m8x3Yecpc
         ho6g==
X-Gm-Message-State: AOAM531teUz6KYVY3PT45BW5edOr1hXdfpFAD1Oh6VTFfBcs61eeiVaj
        o0VQlTkC/+ulBB52nc2WIb4dRIbxPB/HwM2GLSo=
X-Google-Smtp-Source: ABdhPJw+p5LDAu4EWLtXrEVmBgi6I2O8BSJ/cp3rVmaxsAJHduNSbNYqlpna5byopgrCWGY7tfR9Bg==
X-Received: by 2002:a37:e14:: with SMTP id 20mr11478184qko.250.1633371128922;
        Mon, 04 Oct 2021 11:12:08 -0700 (PDT)
Received: from [192.168.4.191] (pool-72-82-21-11.prvdri.fios.verizon.net. [72.82.21.11])
        by smtp.gmail.com with ESMTPSA id g12sm9179316qtm.59.2021.10.04.11.12.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 11:12:08 -0700 (PDT)
Subject: Re: [PATCH 1/2] Bluetooth: call sock_hold earlier in sco_conn_del
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com
References: <20210903031306.78292-1-desmondcheongzx@gmail.com>
 <20210903031306.78292-2-desmondcheongzx@gmail.com>
 <7AEB2618-111A-45F4-8C00-CF40FCBE92EC@holtmann.org>
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Message-ID: <1203215b-13bf-ce0c-ef23-5664544607a1@gmail.com>
Date:   Mon, 4 Oct 2021 14:12:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <7AEB2618-111A-45F4-8C00-CF40FCBE92EC@holtmann.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On 10/9/21 3:36 am, Marcel Holtmann wrote:
> Hi Desmond,
> 
>> In sco_conn_del, conn->sk is read while holding on to the
>> sco_conn.lock to avoid races with a socket that could be released
>> concurrently.
>>
>> However, in between unlocking sco_conn.lock and calling sock_hold,
>> it's possible for the socket to be freed, which would cause a
>> use-after-free write when sock_hold is finally called.
>>
>> To fix this, the reference count of the socket should be increased
>> while the sco_conn.lock is still held.
>>
>> Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
>> ---
>> net/bluetooth/sco.c | 3 ++-
>> 1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
>> index b62c91c627e2..4a057f99b60a 100644
>> --- a/net/bluetooth/sco.c
>> +++ b/net/bluetooth/sco.c
>> @@ -187,10 +187,11 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
>> 	/* Kill socket */
>> 	sco_conn_lock(conn);
>> 	sk = conn->sk;
> 
> please add a comment here on why we are doing it.
> 

So sorry for the very delayed response. I was looking through old email 
threads to check if my recently resent patch was still necessary, and 
just realized I missed this email.

This patch was merged into the bluetooth-next tree before your feedback 
came in. Would you still like me to write a separate patch to add the 
requested comment?

Best wishes,
Desmond

>> +	if (sk)
>> +		sock_hold(sk);
>> 	sco_conn_unlock(conn);
>>
>> 	if (sk) {
>> -		sock_hold(sk);
>> 		lock_sock(sk);
>> 		sco_sock_clear_timer(sk);
>> 		sco_chan_del(sk, err);
> 
> Regards
> 
> Marcel
> 
