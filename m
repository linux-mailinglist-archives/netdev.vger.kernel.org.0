Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 287C919B650
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 21:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732307AbgDATPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 15:15:30 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:38106 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732147AbgDATPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 15:15:30 -0400
Received: by mail-lf1-f50.google.com with SMTP id c5so671190lfp.5
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 12:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gVPmkpSTBz6jopBwqB2iR5d3RsXAeUPQWFT4ekaCFXI=;
        b=R2SQLnGfe6GQfmP4kM+7CAR3fDE7Wz9HrYE5eWe2sq5Lk5GN8P8Jys+BVRV97qc92g
         OGU4maHqG90ibgWu3X716ttXnsOnZaIFYTO5KC1rmhR+8FdhHcMhhK/yJieo9gdFqMkd
         kVf4x3sb+H9L6TktLVdQzNX2GJXam52XChlUFVVM+L8BsTLtnqeZXfvS0AWQjmgXBF8V
         ZLAyJ/LaG2DBCa5LooVW0RrqFRfDOPHmgRlcRoWSIFES2MJ0lZcIdQ+e/sCiZ8I98B+R
         HITHdtRNyy9J0srYGI+MKRVhQIQIH7C1v26+Kc0EEMtD2yM0N9/hQtCm2C1jjjCBIA5y
         8LDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gVPmkpSTBz6jopBwqB2iR5d3RsXAeUPQWFT4ekaCFXI=;
        b=pWr3l112/DAzsnyrqKzelaXXqxZhRfrXGOrJuuc+2oeNJDd0l6kzDO9bdT6vv4vpjJ
         /wfCQCKuTUjuq/7skLxyXnBhl38sTW1mNKPE/w1jKCAQ120UCwJVJIEwDDrs8btZIo83
         rhGhKvGOfZCC1MqF/Sn/B75p6JAp1kfNb53hiXhOnqRCcgrRrVFsLzx/eZElnUxHG3FG
         PVVx0OaaOpwW+klhOx2zNmE9jCQdxkHAtHd7vaoem/ASENXqY1LAAh61wJNrN42iN2mE
         9G24p/MNRyiDzHq7jogl3eBlJp9ATeIYdwtvZfIkimUhHAaHYDLZOozIsUqeVrDUIVCD
         49MQ==
X-Gm-Message-State: AGi0PuYKjB6luUQTzI4Wlm6SkJlvKmUmw9f8Cy5Zd4x93jsCL13kc6CZ
        S8RRTVWX+ybIszn1MGHhwiY06F9DbEgL5lJvSO0=
X-Google-Smtp-Source: APiQypKLKPZAV0qpL30zxWyKSsl3miweRPwyeuOhayEeYVziBmch1gQWXg5Kk726mJwyzO+7roe73cXZPWdg2YLiHa8=
X-Received: by 2002:a19:c005:: with SMTP id q5mr15210278lff.216.1585768527653;
 Wed, 01 Apr 2020 12:15:27 -0700 (PDT)
MIME-Version: 1.0
References: <CABDVJk9Btt8bpXr40EL_O9bqY-wAd7N5P9ghp0kTpDQkc8n4=w@mail.gmail.com>
In-Reply-To: <CABDVJk9Btt8bpXr40EL_O9bqY-wAd7N5P9ghp0kTpDQkc8n4=w@mail.gmail.com>
From:   Anton Danilov <littlesmilingcloud@gmail.com>
Date:   Wed, 1 Apr 2020 22:14:51 +0300
Message-ID: <CAEzD07Jsbt=FBAPWwU-Fyzm58DAMaz45vWot3DgdKRRKNGPMWQ@mail.gmail.com>
Subject: Re: Proxy ARP is getting reset on a VLAN interface
To:     Nagaprabhanjan Bellari <nagp.lists@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ifdown of vlan interface removes the interface completely.
After ifup (recreating) of vlan interface, this interface inherits the
proxy_arp value from /proc/sys/net/conf/ipv4/default/proxy_arp.


On Wed, 1 Apr 2020 at 21:52, Nagaprabhanjan Bellari
<nagp.lists@gmail.com> wrote:
>
> Hi,
>
> I need a small help w.r.t proxy_arp setting on an interface - even if
> I set /sys/net/conf/ipv4/all/proxy_arp to 1, doing a ifdown and an
> ifup on a vlan interface resets the proxy_arp setting.
>
> This does not happen, for example on a physical interface. ifdown/ifup
> "remembers" the setting and applies it properly. I am talking about a
> 3.x kernel.
>
> Can something be done to keep this from happening?
>
> Thanks,
> -nagp



-- 
Anton Danilov.
