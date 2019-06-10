Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC0C3BB4A
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 19:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388571AbfFJRrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 13:47:46 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33771 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387643AbfFJRrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 13:47:45 -0400
Received: by mail-pl1-f194.google.com with SMTP id g21so3969025plq.0
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 10:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5iyIT43p7nr0hkTIsQRIKvE3FYwOGVIejrhgvf/Ywyg=;
        b=yBU6ahjvSniZBVtj2m7Vc9jHFJZbSWi8l2IFASZ+n0F14Y8muDSHk9+ucyi6L+V44m
         Fvjo9+/o4jaJEvp2sEqRkT6PQ19NCTaxijuu4x/BesMYOex2MHf1UtfsCm/FgA6/NrvM
         2RpGK+cfF98p1lJ0GVdJ7dhZNlpmEEJFRV12TTd5e5h14RoaTU+9AhR6tOxZEY0Ow4/6
         tNaIwhoVqlRQ5PLLqJ3RoS6rzWMXwLgCyENiAIWHkpUkLJOZTzubMlcEJfdWaAR29Xs+
         GsL+5dMFn/azc3HlkhgxDNX8BrjNc7KBjARJOWLbsFgv/shfCsQmI6yTcSp2spkxL1Bk
         uwnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5iyIT43p7nr0hkTIsQRIKvE3FYwOGVIejrhgvf/Ywyg=;
        b=fZOrzUgUEIMnU2JXZOaDtegRCKz1b0q/kZfVVOZWyjr7Z5Nl0PYFro7CfZ5n1T7Ndg
         WL45Jtkk733zEP0TiYV8QuMW5/hqJvGaWpX9OiSPo+Pko4rxNBLWLnHIbdD9VwTNbKpS
         F9WUPxLs5Iq1kFcufzUWQBM6azFuv7uSkM38/d7RZI0CK2p46QilKfve30ltgRMTB7qP
         /ogWFl9SAuahLCA6PKqD/z/wVihGsm4Te45Q/1Du78h47Oua8Dxp2j74goZ7H+WtOZUR
         XZqmADdId1Rou8QOJGeKKM8CFt1/mO1x21bhx+3JIn42x9AC7mWZ5EYLq/H55xJuJxFs
         KINQ==
X-Gm-Message-State: APjAAAU9fOrCyzT9xDSR3rknJntFFZ3tz7dhsBR/isNYTveISJxd6evE
        hWkom/TEvQQ65iXV2DR4f4Ga9EOgDDI=
X-Google-Smtp-Source: APXvYqybhpIXf8gnxwQoLSAEMaJDt7Amuk2rtXPj7oi1WHkfQOjnr3fhXEKpP3V840EEc2CqyOqbBA==
X-Received: by 2002:a17:902:2ba9:: with SMTP id l38mr65500049plb.300.1560188864992;
        Mon, 10 Jun 2019 10:47:44 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q144sm8337507pfc.103.2019.06.10.10.47.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 10:47:44 -0700 (PDT)
Date:   Mon, 10 Jun 2019 10:47:37 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, Andrea Claudi <aclaudi@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH iproute2 v2] ip: reset netns after each command in batch
 mode
Message-ID: <20190610104737.3bcd1e7d@hermes.lan>
In-Reply-To: <20190607204122.2985-1-mcroce@redhat.com>
References: <20190607204122.2985-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  7 Jun 2019 22:41:22 +0200
Matteo Croce <mcroce@redhat.com> wrote:

> When creating a new netns or executing a program into an existing one,
> the unshare() or setns() calls will change the current netns.
> In batch mode, this can run commands on the wrong interfaces, as the
> ifindex value is meaningful only in the current netns. For example, this
> command fails because veth-c doesn't exists in the init netns:
> 
>     # ip -b - <<-'EOF'
>         netns add client
>         link add name veth-c type veth peer veth-s netns client
>         addr add 192.168.2.1/24 dev veth-c
>     EOF
>     Cannot find device "veth-c"
>     Command failed -:7
> 
> But if there are two devices with the same name in the init and new netns,
> ip will build a wrong ll_map with indexes belonging to the new netns,
> and will execute actions in the init netns using this wrong mapping.
> This script will flush all eth0 addresses and bring it down, as it has
> the same ifindex of veth0 in the new netns:
> 
>     # ip addr
>     1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
>         link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>         inet 127.0.0.1/8 scope host lo
>            valid_lft forever preferred_lft forever
>     2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
>         link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff
>         inet 192.168.122.76/24 brd 192.168.122.255 scope global dynamic eth0
>            valid_lft 3598sec preferred_lft 3598sec
> 
>     # ip -b - <<-'EOF'
>         netns add client
>         link add name veth0 type veth peer name veth1
>         link add name veth-ns type veth peer name veth0 netns client
>         link set veth0 down
>         address flush veth0
>     EOF
> 
>     # ip addr
>     1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
>         link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>         inet 127.0.0.1/8 scope host lo
>            valid_lft forever preferred_lft forever
>     2: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN group default qlen 1000
>         link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff
>     3: veth1@veth0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
>         link/ether c2:db:d0:34:13:4a brd ff:ff:ff:ff:ff:ff
>     4: veth0@veth1: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
>         link/ether ca:9d:6b:5f:5f:8f brd ff:ff:ff:ff:ff:ff
>     5: veth-ns@if2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
>         link/ether 32:ef:22:df:51:0a brd ff:ff:ff:ff:ff:ff link-netns client
> 
> The same issue can be triggered by the netns exec subcommand with a
> sligthy different script:
> 
>     # ip netns add client
>     # ip -b - <<-'EOF'
>         netns exec client true
>         link add name veth0 type veth peer name veth1
>         link add name veth-ns type veth peer name veth0 netns client
>         link set veth0 down
>         address flush veth0
>     EOF
> 
> Fix this by adding two netns_{save,reset} functions, which are used
> to get a file descriptor for the init netns, and restore it after
> each batch command.
> netns_save() is called before the unshare() or setns(),
> while netns_restore() is called after each command.
> 
> Fixes: 0dc34c7713bb ("iproute2: Add processless network namespace support")
> Reviewed-and-tested-by: Andrea Claudi <aclaudi@redhat.com>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Applied, thanks.
