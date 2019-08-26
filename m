Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE49B9D488
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 18:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732397AbfHZQ4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 12:56:10 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38436 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731603AbfHZQ4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 12:56:09 -0400
Received: by mail-ed1-f65.google.com with SMTP id r12so27429823edo.5
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 09:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=67BAtme5Bn504s6y8f5kDMGjE9Fh27NKTnaL+bb5a4c=;
        b=C4hYTc6JH/lzSe4IpgVDlgl41vTAKsIvu0l5BT5TBX8zOFjuCe2E0nvSlRTarBh+MV
         fN1OiYSY7472g5CiE5w2D00ZDnbkgihUPEz4L/K94icATFlsaZ5TmlOjx5PLe2Y/HZK7
         M9OlJCHhBoOsI6gUpKAEyNc14L0AIwHkWdo0BmAWaClZ829LO1Tv1t18zmJv5NELDv8P
         DIJ8e2NWRdKHprUqBYit7rHg8VUyrAFSxHv9Y+gUQey3V9PwR7emxy0KjX2rJH7e3VMd
         HgXejkItEW63MIUud9tvlEsK+W4JP22hBSkpt+TsoLMaIF9QbSZgo2LeNcAVPo69Riy9
         apZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=67BAtme5Bn504s6y8f5kDMGjE9Fh27NKTnaL+bb5a4c=;
        b=UJ13elq4hNQi7JvTiPb5+JrX1p0LdOBL0kOQjWYOvYCxsceR9BJhWJzN6az1tsUBqw
         ZpHeAaOrAaIlyHQ1m96V5hETQbL/JZJPHIjCPOLxEHWe5iBBOJoBKCcOhFgsff9AQLoH
         /G/Cr0twluBwfeYEmKmRQA0o72JBLAGy6qD6Bi+/vpCZfVBvldJhB7PSnL2HWC0OUA7A
         1HVkDk4ekwkRkFP5GIFk9O/A02AvPT8bJ/HdMJ3TH6SU6iqn9dWHs2+MCnPdriSvj0CW
         mg96zJ2mYWF9s8pajZ62aKTPDLJOl5Y2GRqcBRze9M03Q996QumjD0z4hkypDAu5Hb2V
         9h6g==
X-Gm-Message-State: APjAAAUUY4kw/djHvy1E+0FyAQX4OtlUg3jyZRusobB6lMtBqTUHCHcb
        OOLVtC2ckHXYnyw2gcIXWXeStg==
X-Google-Smtp-Source: APXvYqxmHPnBXbtB11tnf7zeqvbkuNR51sUSJoGrnPBQKTCsOmFkHy2j2R1dsu7ipSQbRCwCEJcgCQ==
X-Received: by 2002:aa7:da97:: with SMTP id q23mr19782632eds.132.1566838568042;
        Mon, 26 Aug 2019 09:56:08 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id qx4sm2980920ejb.11.2019.08.26.09.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 09:56:07 -0700 (PDT)
Date:   Mon, 26 Aug 2019 09:55:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add
 and delete alternative ifnames
Message-ID: <20190826095548.4d4843fe@cakuba.netronome.com>
In-Reply-To: <20190826160916.GE2309@nanopsycho.orion>
References: <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
        <20190809062558.GA2344@nanopsycho.orion>
        <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
        <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
        <20190810063047.GC2344@nanopsycho.orion>
        <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
        <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
        <20190812083139.GA2428@nanopsycho>
        <b43ad33c-ea0c-f441-a550-be0b1d8ca4ef@gmail.com>
        <20190813065617.GK2428@nanopsycho>
        <20190826160916.GE2309@nanopsycho.orion>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 18:09:16 +0200, Jiri Pirko wrote:
> DaveA, Roopa. Do you insist on doing add/remove of altnames in the
> existing setlist command using embedded message op attrs? I'm asking
> because after some time thinking about it, it still feels wrong to me :/
> 
> If this would be a generic netlink api, we would just add another couple
> of commands. What is so different we can't add commands here?
> It is also much simpler code. Easy error handling, no need for
> rollback, no possibly inconsistent state, etc.

+1 the separate op feels like a better uapi to me as well.

Perhaps we could redo the iproute2 command line interface to make the
name the primary object? Would that address your concern Dave and Roopa?
