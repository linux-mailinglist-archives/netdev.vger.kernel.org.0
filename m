Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 449A01C83A
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 14:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfENMKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 08:10:45 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:43031 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfENMKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 08:10:45 -0400
Received: by mail-wr1-f49.google.com with SMTP id r4so18917128wro.10
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 05:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g44TdQyR7Yn7TL6DU3Y83p6mvX6Hp2k3jXyhfQ84eIE=;
        b=AD3o0ekl9iGQqnoUoMGd4yptErkqcYgNKPuQWw48kcIOkPhaTDPW+A1sqjZEzF/xgi
         yCnNCsXtavN5vCBPpwEAuuKZXsoDBX9TWJuc4KsVtW/qq43Ks1wK6hMGuC7oXr6Zi3Gv
         eew8Vyx4MfM64Sxh0Ye6qXIGFdBR6twZmWmKhsspkfLtOTA+7sOkQd6PUUPh0YIvQnsC
         WT+fRmn9tFdTLqXOhG/lCqMYUdgkrVnzDQSAxK8SmXsWEQtRI1nXR8/Fv4DW8nwAvanj
         5nKC3BqIH0g3sOk6c3I/Y9nrNb1lMnAHYYhmn3mrPpZDgfUBPCCLVherJWKiGGM+Cabp
         3zDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=g44TdQyR7Yn7TL6DU3Y83p6mvX6Hp2k3jXyhfQ84eIE=;
        b=PNpQwo2bZkfXXljnXpCOEsxz+tqJJn/kfCtczOOVLwYV+x3srnnMQPsFSwjPpYYTUw
         ums8eJVWh/QGmgRpr06KVA2TT/HVAawY8XuO2RcomjOX06D/C9nxXntNyNdPSaMnE3PJ
         VrTJUBQf+1BdgGpeWwPXxJDVCWCgzSBWrrlRsPY+i3ft8YzUlQJG5BcAR1Y/0FhpheIu
         cyNYYno8UHkstRJ1tpl67Cw810rYNsPhSPuDwGkp4seufWFxq1KFjxwoqZhkjJN8NbCj
         UUhZX2vjwUEnp28XYq9RiBlSpJJ6q+n2i4mmUFpgtcVf/ENHDcEHIDTq1yZOwGnovrHk
         l+xg==
X-Gm-Message-State: APjAAAXBUi0ILkO9c5odwSa6iOGKKtsMlUpFC5t6lATuxWAwhrWHfohF
        BsVAPl/RWglM202HSSqslstUzg==
X-Google-Smtp-Source: APXvYqxY16+7eJcQnr8tllCEhdBo7uI3yWM57Gni9aDO4al2eKZ2OwM9fzorF2PuECBcW6n0kpriCg==
X-Received: by 2002:adf:e902:: with SMTP id f2mr21615923wrm.301.1557835843341;
        Tue, 14 May 2019 05:10:43 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:64b3:e115:e5ef:6e9d? ([2a01:e35:8b63:dc30:64b3:e115:e5ef:6e9d])
        by smtp.gmail.com with ESMTPSA id v5sm39957201wra.83.2019.05.14.05.10.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 05:10:42 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net v2] rtnetlink: always put ILFA_LINK for links with a
 link-netnsid
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Dan Winship <danw@redhat.com>
References: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
 <b89367f0-18d5-61b2-2572-b1e5b4588d8d@6wind.com>
 <20190513150812.GA18478@bistromath.localdomain>
 <771b21d6-3b1e-c118-2907-5b5782f7cb92@6wind.com>
 <20190513214648.GA29270@bistromath.localdomain>
 <65c8778c-9be9-c81f-5a9b-13e070ca38da@6wind.com>
 <20190514080127.GA17749@bistromath.localdomain>
 <7c8880b4-86a0-c4b0-4b92-136b2ab790db@6wind.com>
 <20190514102415.GA24722@bistromath.localdomain>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <73fcdf4c-5c0e-31c6-66fd-9419d6d7c1e5@6wind.com>
Date:   Tue, 14 May 2019 14:10:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190514102415.GA24722@bistromath.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 14/05/2019 à 12:24, Sabrina Dubroca a écrit :
[snip]
> Yes, that's possible although quite unlikely. I'll go with d8a5ec672768.
> 
Agreed.


Thank you,
Nicolas
