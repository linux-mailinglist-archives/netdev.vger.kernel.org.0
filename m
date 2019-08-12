Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADAC08A22C
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 17:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbfHLPV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 11:21:56 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40721 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbfHLPVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 11:21:55 -0400
Received: by mail-qt1-f194.google.com with SMTP id e8so2646722qtp.7;
        Mon, 12 Aug 2019 08:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HGNfZqb//UE8Rwbt9ezhCRmZv0hIhCrmCUMdoLSoZzg=;
        b=Da6iRB9rFTs7lc+LG4fFemCiG9uF5zxlB+oaqFVGCQBkulwnlRZexoCYW5S/q4qqzQ
         FgMD29oTGWmDkVvLCp7EOogIiWF/gIFm+4j8h2NWNH3Lv+HqAR1As9Cla3SF/KXFfqLR
         RWNFYyIhh3byvCeEKMMOcvPZe1rvgo2Itj5fTCDOOAD4ljYQBqC0IiCGWzXHh0PY3l78
         fO5BynvzgqRZkYTShkIM7+aCeHm05ZvxUBOcmOP3HBRVFURhToU7PGv20CMishawSFfG
         FJblyv7z8CV+1kfqqSXBzFtOZ5nCwtQqho2QLonsZ1zb0IP6VDUXqMcylh8IbKLQaKkt
         ljyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HGNfZqb//UE8Rwbt9ezhCRmZv0hIhCrmCUMdoLSoZzg=;
        b=Mjlz5iD9Z+jNJ6IFwmxryv+BRWBYWkVKjMSMjRhS0MzENJEDJQKlRe19LRxH7jZVVn
         YvPTxUjcpgoSo7K1pniaW89Ge1+KQMZ7D7FfBfOYcutVKbyM4M05Q6zn5KztIIaqDmsF
         /b45zD8PxxOvYXBhyTd4qq1/chh+05FYe0vIM/RwJLP5pG9dfJpkefQt/SLAex2rEUzR
         co8LPkaxLhCupxlIEQCLGvfjpdnLUAfNPUtJd95E9J8OzB6mAx7QSHzGvTuvCjj5PAXe
         PUMNoL4hlE6aefMK7Kp/39gL3DSfkV/zRnhxqWefSgIFjOIY5/7cO20gWCnommu6BmsH
         wU8A==
X-Gm-Message-State: APjAAAW9RYAMK39mXSnU6qSzW7K/JFvDZXeGmhKuNPTcyv0e4vQSXyhs
        foiRRS6YDlu8DxWBimme57Y=
X-Google-Smtp-Source: APXvYqzvT1LrfNnS7N4q3ahnxX+gHCw/UxmIyNQJLfT0ExKpyxBZuE1thu3aMF/vsubhv2RVfvgFBg==
X-Received: by 2002:ac8:31dc:: with SMTP id i28mr31271085qte.226.1565623314356;
        Mon, 12 Aug 2019 08:21:54 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11c9::1085? ([2620:10d:c091:480::d0c4])
        by smtp.gmail.com with ESMTPSA id r4sm68259567qta.93.2019.08.12.08.21.52
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 08:21:53 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [RFC PATCH v7] rtl8xxxu: Improve TX performance of RTL8723BU on
 rtl8xxxu driver
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Chris Chiu <chiu@endlessm.com>, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Daniel Drake <drake@endlessm.com>
References: <20190805131452.13257-1-chiu@endlessm.com>
 <d0047834-957d-0cf3-5792-31faa5315ad1@gmail.com>
 <87wofibgk7.fsf@kamboji.qca.qualcomm.com>
Message-ID: <a3ac212d-b976-fb16-227f-3246a317c4a2@gmail.com>
Date:   Mon, 12 Aug 2019 11:21:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87wofibgk7.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/19 10:32 AM, Kalle Valo wrote:
> Jes Sorensen <jes.sorensen@gmail.com> writes:
>> Looks good to me! Nice work! I am actually very curious if this will
>> improve performance 8192eu as well.
>>
>> Ideally I'd like to figure out how to make host controlled rates work,
>> but in all my experiments with that, I never really got it to work well.
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>
> 
> This is marked as RFC so I'm not sure what's the plan. Should I apply
> this?

I think it's at a point where it's worth applying - I kinda wish I had
had time to test it, but I won't be near my stash of USB dongles for a
little while.

Cheers,
Jes

