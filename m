Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2FF5BBE64
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 16:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiIRObm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 10:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiIRObl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 10:31:41 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF471AD9D
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 07:31:40 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id go34so59085555ejc.2
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 07:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=Tdb4uBYHGKqcCBGH9t1Nznox3MFYvtzmoPZEjJD5iyU=;
        b=lpjM4hmJWq0vhBNDoKIrfKdVnEk2HQEjs9g6xVJN0zxQstscP/lUH0kuxr//JSnznB
         WlE2FdSLzgh8q1epVAp8RK24UcwlWK55qsbrn+fvmfH/L2hbZEY0fEh1r8HXPhgLWYKD
         SQ2889BdBAKPhcTZa48GZod22c19FWpCsbq7ax55EPgnMfiZLa2cnP16U60AHnEepvTt
         ltsYxdXOA8LKpjn8xqU7XHZDv3pyTaRb2eo7x49Ua3kfSlDvPA6duMcKSk7DM4jueA08
         LbpomnRc6LqT1vJH1PdcCgFFwQUcuX83+RvYoKaJ+cGoDbdXp5dz1O1U/I6A2LgwhoTW
         fU5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Tdb4uBYHGKqcCBGH9t1Nznox3MFYvtzmoPZEjJD5iyU=;
        b=d1Q6bdMzb5GqziNVyw64+f56bzkT0Vj1r7XaH6eYjHsgn5QIiWNLoc0ZDJOzyvEeMI
         /gVYnmteATRtDucgwAhLecEdRnk+N2C6dqZnyO4ZwBocNekgQla1BRY6AAZlYuwUJ2/D
         gG5+VHHum8iSgDHF2sPIKMQAh2JXVDbrQ86QTw8BjN74VEULXngS6LTF4QE/KFhmxkMr
         b1jGtnTcPc1H2qcxOCLN+AMfZS1iGigB1KnY3a9cS7guSNvaZUXGN6kxmMAqwPEqAuxY
         TrbPg1oq3Mnr2UsuarT2cToTkdBYToDmorWy5eigDe4ra/mw2BPnZfh19enAvYfzqkGS
         SigA==
X-Gm-Message-State: ACrzQf35ceZ5F4DNT4n4ACxQ5vVXzxZEijYoJX92cj1Ax8yrYj6pQUX8
        1QLWUcT5eVwvrV1qg4iFItM=
X-Google-Smtp-Source: AMsMyM65n4XEeVQZatjrOvfG3jadA+wTUIpRLMtTdBYqxqarjh1t1F8XNk2VlQKmaWUF5DVkAOiNug==
X-Received: by 2002:a17:907:ea6:b0:77e:156d:b07b with SMTP id ho38-20020a1709070ea600b0077e156db07bmr9592125ejc.435.1663511499263;
        Sun, 18 Sep 2022 07:31:39 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id p8-20020aa7d308000000b00443d657d8a4sm17773180edq.61.2022.09.18.07.31.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Sep 2022 07:31:38 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Bug Report kernel 5.19.9 Networking NAT
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <YycrJqcuQJOVCvr6@kroah.com>
Date:   Sun, 18 Sep 2022 17:31:37 +0300
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>, pablo@netfilter.org
Content-Transfer-Encoding: 7bit
Message-Id: <02A88BC2-8A0F-4E7F-B5FB-5FB5CFFD018C@gmail.com>
References: <7D92694E-62A2-4030-8420-31271F865844@gmail.com>
 <YybvTYO2pCwlDr2f@kroah.com> <91719698-62E7-4447-8220-CBA64F0BB5C9@gmail.com>
 <YycrJqcuQJOVCvr6@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

now it started giving it, I think it was always here
And yes is new for me .

what can cause it?

m.


> On 18 Sep 2022, at 17:28, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> On Sun, Sep 18, 2022 at 04:49:26PM +0300, Martin Zaharinov wrote:
>> Hi Greg
>> 
>> Yes still receive this message in dmesg this is kernel 5.19.9 : 
> 
> Wait, but that's not what I asked, I said:
> 
>>> Is this new?  If so, can you use 'git bisect' to find the problem?  Or
>>> has this always been there?
> 
> thanks,
> 
> greg k-h

