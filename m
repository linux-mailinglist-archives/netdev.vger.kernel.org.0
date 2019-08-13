Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA6F8ABEC
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 02:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfHMAXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 20:23:08 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45088 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbfHMAXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 20:23:08 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so50289209pgp.12
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 17:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6DdOpjgP28z9aBLVJ1dXSUSlKLIafFf73UkK3U9xzEQ=;
        b=auw/1ui7Ew9nHIiiT2WGrQSWqeS2l5mpj8Lg/kLh/txFRUzrK50EjCLVIeLxuboYKA
         lZKKQZhB2rTETZ9pR5F6Ctbq+o55XgiJ9J8gnQGtmfoUmEhtgN2sdaLEWqZqBr4H+73e
         r7mnzMC/kOTBGQiK7qvgJjZGwKxyPpCjNspbaCI9EtdK/QkrTFuidct0jUXZmsDbwmjl
         1EFbtuLmWdnquf3rO9XhW+xfQSJRe/8YgBnV9VcLtxC0Z7FJOGOJtj/hYRPvMZX2K3cz
         PokxEj7T02UhTrpwTGS1Tijim6LkOhZzEmkGg+Cx+ZSoJ4moC4CpepFLUBOdhNeVnymC
         Ve9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6DdOpjgP28z9aBLVJ1dXSUSlKLIafFf73UkK3U9xzEQ=;
        b=kONQTbGcqIuTgvB2iz6xFNq1qYKBTVTVfqp6j2bmW/WxuoVUgb2kPluX4lIuG0tuUD
         OYabCAE9C4hJ3sVmEH8RlHg9wJLog/KdkCiXAPFW0/SGR9CNHgP+NKTRp6kpi63BPJNK
         vtj+ELq1bpGUCN2JkQw1NwJrjMH12tEWn3KpyC/5UzebXKp44TWnAArEGuphtqusI2XI
         2R9mAnQf1NRZ5+vWGWU4DVVPnicg0wqN+DZDwmWkaWrcMS19XWv1j8EgwVI/WsJBxGCI
         oIAaKXeTZ/6U0K5ewHJBgzZbGHMuC8sniBIQtplQiqVhpfIwXF+sfalMmJHHadjS6eAE
         S+VQ==
X-Gm-Message-State: APjAAAUr5VHSWnBGqu0sM14RwcLCcT5eTNPBRe3zGELG0V8B+C/ABTi+
        BZXBF3qeL76s8gVfUSHUsOg=
X-Google-Smtp-Source: APXvYqzAEOeFZupPe3idi6U+zc3HlIVn+HIQd8ppBt4WR7QFcL6tMzP9B41EwNoJWDBz8ANuc+JxIQ==
X-Received: by 2002:a63:d210:: with SMTP id a16mr18429533pgg.77.1565655787739;
        Mon, 12 Aug 2019 17:23:07 -0700 (PDT)
Received: from [172.27.227.188] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id p10sm4036580pff.132.2019.08.12.17.23.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 17:23:06 -0700 (PDT)
Subject: Re: [PATCH net] ipv4/route: do not check saddr dev if iif is
 LOOPBACK_IFINDEX
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     liuhangbin@gmail.com, netdev@vger.kernel.org, mleitner@redhat.com
References: <f44d9f26-046d-38a2-13aa-d25b92419d11@gmail.com>
 <20190802041358.GT18865@dhcp-12-139.nay.redhat.com>
 <209d2ebf-aeb1-de08-2343-f478d51b92fa@gmail.com>
 <20190811.204918.777837587917672157.davem@davemloft.net>
 <20190813005830.41f92428@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6fe3318a-727d-99c1-078d-2ba879de3749@gmail.com>
Date:   Mon, 12 Aug 2019 18:23:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190813005830.41f92428@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/19 4:58 PM, Stefano Brivio wrote:
> How so, actually? I don't see how that would happen. On the forwarding
> path, 'iif' is set (not to loopback interface), so that's not affected.
> 
> Is there any other route lookup possibility I'm missing?

Use case is saddr is set and FLOWI_FLAG_ANYSRC is not set and that seems
pretty common to me. From a quick look, icmp_route_lookup,
ipv4_update_pmtu, ipv4_redirect, inet_csk_route_req, ...

Enable trace_fib_table_lookup and look at the flags for various use cases.
