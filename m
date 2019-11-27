Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBF510AFFD
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 14:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfK0NOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 08:14:12 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43384 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfK0NOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 08:14:12 -0500
Received: by mail-qk1-f195.google.com with SMTP id q28so443748qkn.10;
        Wed, 27 Nov 2019 05:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=tKU4ythhj/IOrUSC8YM0GQ9azaoq8ej8gEJR824Q+qQ=;
        b=gk5fN9CpW4d5L6Trae5cnloGnvV3fZQZVUMAVnYEDz7dY/CgIszYnd0ytdry/TSmUM
         THmphwEJDaB1PrbCQxgoDrZqmywQpdHkyAO8wpIzfAEq+4fYfUWDnFTarNNW2nZfpdQz
         hOBlmz4hyFcEZwLYwwy/pf4SatxAnlR2po42zD8pO9QoYCTVp4XopA+d1gQW8Kz4aBot
         8jlqH0x0K1008tTTopESeFdSDoY9KNSLe51IbzvK+htiQ2wWnYsCKNU9UF6JsUhKXo0v
         cxtt54YxV4tdnuHFiiPVJsalm/+x5CBDnpRtUiKAhPIBxccc0Iaol1YCSFj8mIoYkwjY
         E9rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=tKU4ythhj/IOrUSC8YM0GQ9azaoq8ej8gEJR824Q+qQ=;
        b=ANqpYjDsyiyDokn/xenp/5iadbd7UcKO3KNXm3y2mMP046v0S10/VX+/RYuOLTyELC
         UljOZspnn7CBYXlrIzEwRn3mr4nHvisuN6lvkpf9NiNDk8nGe4aLI1oeRR4NB3l3vyM8
         we7wIuZ0X2YncfH1xoba6Ce09WRlDiaj7upJgjky3LSNqHaJz3l4zR1YdQq+/Af2gDcb
         CwnbYQR2IIel3n3jDMIv+1oYQDBqcuyyxp2/NL1lsxYK4AddlvvMYeiT0i4ZMjPaUPV8
         wOvzfvPVHFLiiEMdQyDuv7ZgDfh203jV5eVlywZoisrXL70zrRw0+I9ZE8jdiFafVvs+
         tj4g==
X-Gm-Message-State: APjAAAWl4EX6n6gx0HQYye+ykZ/y+AKe6qvzVnSNY6WxYosmFS0T8Eh9
        c6kfWFj+vb+oo03FjUHCe34=
X-Google-Smtp-Source: APXvYqy8HojzKwysLLuCi9ir+JXbM8z+DD9nwNf6+GA9NlEtCdysn2BJZUp2/8qfL30wWpgotmyXkQ==
X-Received: by 2002:a05:620a:a1a:: with SMTP id i26mr819123qka.383.1574860451228;
        Wed, 27 Nov 2019 05:14:11 -0800 (PST)
Received: from localhost.localdomain ([168.181.48.195])
        by smtp.gmail.com with ESMTPSA id r4sm7642974qtd.17.2019.11.27.05.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 05:14:10 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 43A6EC510E; Wed, 27 Nov 2019 10:14:07 -0300 (-03)
Date:   Wed, 27 Nov 2019 10:14:07 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux SCTP <linux-sctp@vger.kernel.org>
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
Message-ID: <20191127131407.GA377783@localhost.localdomain>
References: <20191127001313.183170-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191127001313.183170-1-zenczykowski@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 04:13:13PM -0800, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> and associated inet_is_local_unbindable_port() helper function:
> use it to make explicitly binding to an unbindable port return
> -EPERM 'Operation not permitted'.
> 
> Autobind doesn't honour this new sysctl since:
>   (a) you can simply set both if that's the behaviour you desire
>   (b) there could be a use for preventing explicit while allowing auto
>   (c) it's faster in the relatively critical path of doing port selection
>       during connect() to only check one bitmap instead of both
...
> If we *know* that certain ports are simply unusable, then it's better
> nothing even gets the opportunity to try to use them.  This way we at
> least get a quick failure, instead of some sort of timeout (or possibly
> even corruption of the data stream of the non-kernel based use case).

This is doable with SELinux today, no?
