Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6143DE6D54
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 08:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732319AbfJ1HiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 03:38:03 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42641 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729420AbfJ1HiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 03:38:02 -0400
Received: by mail-wr1-f67.google.com with SMTP id r1so8671144wrs.9
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 00:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DdypZHLrKa7TVi8gRS0GU+loqobZcRyMq1zPxMplx9g=;
        b=Oto1zxac4tS2ogiCydsNw+kunj6gCHg0v98m8qLUDRRZUsLvi05+3wwvyBi4LuLJ/k
         tKEfV10DasI4n/ToqayQbwnkzdbiO4qfQ1NfuUuUoadYrOxwBnOd1CMjtsP9d9hBbcZv
         p8iDg5utDDTp3Cw+SS8uVpYiX6qWkSgiSLG2ApIuqerzSL5dlwfsv8DfDNym7pb8fZbF
         LK7p1TXbkYepEGp9OtQZG9Bmg6BjeLgn8Owv0UGW/a1jBKbWvKiDoS/bwVpM8CKbDm/5
         b2lBrzR4NVelbzTyHUPLx2m1Puvg4cekkiobEmmVtJb0DECl549+EFULFJYN8NbSsecG
         1opg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DdypZHLrKa7TVi8gRS0GU+loqobZcRyMq1zPxMplx9g=;
        b=n3+ZR7Ue9lImTc2+lr5AHDcXnKe/BWSSr1YubvVI3FL9vaSPxe81RcS9t5mZkngyoz
         KHA4s7m5IhIDn5yZ+YasDfbdULCxZy9YF/hNn6GKhWd6YlAVZbvhfpnZ94/WKUoZvXXe
         Yu6EVm8lw2EIbKundYluodJiemt+Szjmb5BiwWDrRjqFe0crH7pCxrLRDIJ4m+5uF+Nq
         7s/08pbnAhvRwvyBl9sZqEmv4QOe1D0Nt2lfbdd7gFTrZEusJXIG19gOVidVJe6M1H94
         abS18xDPzoGDaXuX9fEdl015ow0tKX8BciFvgOyNpkTtmRybBojhUW6zynme8bwru4qR
         vo5A==
X-Gm-Message-State: APjAAAXWfXkUutKywY8GmYPENFjQkWi4dyrppdEsRUz1TnFgllOGN+fN
        +2OUgxlrAenVRpa17ezsGewD6g==
X-Google-Smtp-Source: APXvYqwcj87bw8lOVArXqR+XJGvgvLYer6ZYl0POgShlbgBJ+FZeP+VM8gD31aCkMJZMAgzJR/ZIwA==
X-Received: by 2002:adf:fcc7:: with SMTP id f7mr14071702wrs.345.1572248281259;
        Mon, 28 Oct 2019 00:38:01 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id o73sm10913132wme.34.2019.10.28.00.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 00:38:00 -0700 (PDT)
Date:   Mon, 28 Oct 2019 08:38:00 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: Re: [patch iproute2-next v5 0/3] ip: add support for alternative
 names
Message-ID: <20191028073800.GC2193@nanopsycho>
References: <20191024102052.4118-1-jiri@resnulli.us>
 <c8201b72-90c4-d8e6-65b9-b7f7ed55f0f5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8201b72-90c4-d8e6-65b9-b7f7ed55f0f5@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Oct 27, 2019 at 06:16:25PM CET, dsahern@gmail.com wrote:
>On 10/24/19 4:20 AM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> This patchset adds support for alternative names caching,
>> manipulation and usage.
>> 
>
>something is still not right with this change:
>
>$ ip li add veth1 type veth peer name veth2
>$ ip li prop add dev veth1 altname veth1_by_another_name
>
>$ ip li sh dev veth1
>15: veth1@veth2: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state
>DOWN mode DEFAULT group default qlen 1000
>    link/ether 1e:6e:bc:26:52:f6 brd ff:ff:ff:ff:ff:ff
>    altname veth1_by_another_name
>
>$ ip li sh dev veth1_by_another_name
>Device "veth1_by_another_name" does not exist.
>
>$ ip li set dev veth1_by_another_name up
>Error: argument "veth1_by_another_name" is wrong: "dev" not a valid ifname

Odd. This works for me fine:
bash-5.0# ip li prop add dev veth1 altname veth1_by_another_name
bash-5.0# ip li sh dev veth1
4: veth1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 82:ce:19:28:bb:f5 brd ff:ff:ff:ff:ff:ff
    altname veth1_by_another_name
bash-5.0# ip li sh dev veth1_by_another_name
4: veth1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 82:ce:19:28:bb:f5 brd ff:ff:ff:ff:ff:ff
    altname veth1_by_another_name
bash-5.0# ip li set dev veth1_by_another_name up


Did you by any chance forget to apply the last patch?
