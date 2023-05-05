Return-Path: <netdev+bounces-527-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3A566F7F49
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:42:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D6E01C217D7
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 08:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E2A65396;
	Fri,  5 May 2023 08:42:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622491C16
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 08:42:02 +0000 (UTC)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744F214922;
	Fri,  5 May 2023 01:42:00 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6436e075166so1172330b3a.0;
        Fri, 05 May 2023 01:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683276120; x=1685868120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NXc+JQG7sjSWV4KJri3HwwYNBJnjv1LP700li+2vJpk=;
        b=liAzfXMgF8QV+ZOFlitv2hJtS68QoDWaYGNh8NoIcx36fuuhim2DdXllAO4i7tEPzc
         dS6LxplAUdKdNLxG525Wbs+S6KLYjoBo2J2BolqUDiI0AHnwcBUnXpr/lux1hDLVyqyf
         X+dUKTPgND7Ei8YAs5tNaASMCWmpgFzeUkhiXFo8MEGSpsEpDHYhrOBOtmrWDGBsN/4J
         BuweeYGvlgT6402JsCy17TPqGjUTSZTwrgkrx4ou0XkYUSFBtVQyuyj3ihYF5QxboB2h
         dZ/+rQULLigILUvmKTapkmK/JviuRUy/z2s3dO7C0dZErKlEzGCQi42U8A/1FHsIQWp7
         v4ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683276120; x=1685868120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NXc+JQG7sjSWV4KJri3HwwYNBJnjv1LP700li+2vJpk=;
        b=foW7aRTpIEXD9oYr8V3GvKrEY0prsYJfPUb5+hTXWkn79gACxA3NGDZLpSOI/3fsM1
         k1HFPcQEMt/0mh60kWYZKiMRQdGPnjD2FNKVxPVLLjaIlSexoTJbo0Dy/fNsbfnR/9hZ
         OfAb5eZsA33hoP6flfxecPd5+BGnHvxXV5MAbgXVzP4Zv27s9oRZhs5jFTV5woht8peq
         Pgw4iksIOqL7bcsNq9eQ2WxJHGehQ6STN6hUzWEugnMNTUv4eWymqoHgVcQQCO4ewh+H
         6rC6JVL58fEs3+F7ze4yt4DlsYGS6W7ii4rfCRjJ8e3wqxv1R9DC/ludm4271BRW695x
         D7cA==
X-Gm-Message-State: AC+VfDzIH+Mfw4J7DEjTIjg8Q96KCR71yMkH7WLlSxHu6DWvCleHhADR
	xD4kpUvmoppTz3IRVKF171E=
X-Google-Smtp-Source: ACHHUZ4/wnSluHbwWlNwnWEKLOGHEaewPuO5q/mtk1Z+g2fuh0VDKyDR6T7ExAUfLM9Me7+dgr5fTg==
X-Received: by 2002:a05:6a00:240b:b0:639:28de:a91e with SMTP id z11-20020a056a00240b00b0063928dea91emr1419883pfh.17.1683276119558;
        Fri, 05 May 2023 01:41:59 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g13-20020aa7874d000000b0063b6bc2be16sm1119416pfo.141.2023.05.05.01.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 01:41:59 -0700 (PDT)
From: ye xingchen <yexingchen116@gmail.com>
X-Google-Original-From: ye xingchen <ye.xingchen@zte.com.cn>
To: jasowang@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	ye.xingchen@zte.com.cn
Subject: Re: [PATCH] vhost_net: Use fdget() and fdput()
Date: Fri,  5 May 2023 16:41:55 +0800
Message-Id: <20230505084155.63839-1-ye.xingchen@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CACGkMEsmf3PgxmhgRCsPZe7fRWHDXQ=TtYu5Tgx1=_Ymyvi-pA@mail.gmail.com>
References: <CACGkMEsmf3PgxmhgRCsPZe7fRWHDXQ=TtYu5Tgx1=_Ymyvi-pA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>>
>> From: Ye Xingchen <ye.xingchen@zte.com.cn>
>>
>> convert the fget()/fput() uses to fdget()/fdput().
>What's the advantages of this?
>
>Thanks
>>
>> Signed-off-by: Ye Xingchen <ye.xingchen@zte.com.cn>
>> ---
>>  drivers/vhost/net.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>> index ae2273196b0c..5b3fe4805182 100644
>> --- a/drivers/vhost/net.c
>> +++ b/drivers/vhost/net.c
>> @@ -1466,17 +1466,17 @@ static struct ptr_ring *get_tap_ptr_ring(struct file *file)
>>
>>  static struct socket *get_tap_socket(int fd)
>>  {
>> -       struct file *file = fget(fd);
>> +       struct fd f = fdget(fd);
>>         struct socket *sock;
>>
>> -       if (!file)
>> +       if (!f.file)
>>                 return ERR_PTR(-EBADF);
>> -       sock = tun_get_socket(file);
>> +       sock = tun_get_socket(f.file);
>>         if (!IS_ERR(sock))
>>                 return sock;
>> -       sock = tap_get_socket(file);
>> +       sock = tap_get_socket(f.file);
>>         if (IS_ERR(sock))
>> -               fput(file);
>> +               fdput(f);
>>         return sock;
>>  }
>>
>> --
>> 2.25.1
>>
fdget requires an integer type file descriptor as its parameter, 
and fget requires a pointer to the file structure as its parameter.

By using the fdget function, the socket object, can be quickly 
obtained from the process's file descriptor table without 
the need to obtain the file descriptor first before passing it 
as a parameter to the fget function. This reduces unnecessary 
operations, improves system efficiency and performance.

Best Regards
Ye

