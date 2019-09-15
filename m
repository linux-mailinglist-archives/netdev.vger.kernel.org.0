Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D26AB314B
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 20:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbfIOSCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 14:02:02 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39112 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbfIOSCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 14:02:02 -0400
Received: by mail-pf1-f193.google.com with SMTP id i1so12397597pfa.6
        for <netdev@vger.kernel.org>; Sun, 15 Sep 2019 11:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GjfbtTr3E1bejfRUytv51nxmoZA8mF2wwqSzWFHcbqM=;
        b=g1rCar93hFhFQ2CN9RyWA9u85deQYZ/URv+Z4diY0l9bP8x9T+/y0UioLumFrA7CRy
         SLFmDNnl2Y86TIOsHLc6hF5cODr05GODWx/FWF+tWg9fVtn26ztLhdhMfIwivzZonAOE
         VFmnEJVOhQ6W6ysvaH6xaAx5taretj+VMrEAPGq6YxCy6OeVaSX2c84qalq+1i+LhuaM
         7uL8RdHWF9EtlcFUpBXtpyTQwEJbuhYKydc6hTtnKyRmkMQVpDeSIl9vJerYf5nRxmFv
         t/q6i2tpknqCU1dkoKf+obHY/G+xsKbB5odXpkEeL8Pm9eQdLhx50kHB/NWapJVE+uB3
         cOhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GjfbtTr3E1bejfRUytv51nxmoZA8mF2wwqSzWFHcbqM=;
        b=ASZoo91fJhgCbz9j63gbhb1YDLvy/tekaAbc7RwevPNdO4NnfYKMX2k5taqGvy0Qxg
         07tCTDKOMYugokyd/P4PZC+1VzmW6wTNzuYW8XZCAyW8kekMUAdXjMWJEcRlMZQ9aywW
         DUt/0dAsPyFh3k2tmUA9fsHaDUxMLLFkDKgAGFTfN+qNem5fsKQ+ACcJRacLJcnthPlz
         WeCRBARnA62+AxqyP1CQW1zV0ZYjGdGJH1QW7WaiW5njljB8eXIdsa8ITKEEzNDjMk0o
         H9CMnUX+L/hDuMkUuAlZ4qdvi031PX0SkV1dKLIDTdfbp7mcUv65odOPsQ5ff3Z5cEHW
         VxJQ==
X-Gm-Message-State: APjAAAXlID55TyWxuKYRHNJRA6G5KcTzBEJxwkq5HjMsJk/IseDEs9ws
        DAspyBDlOkPzSVco5mWs+3A=
X-Google-Smtp-Source: APXvYqwkP5Wtxe2RL758e36WblHvsTMSkEtilzHJEe6iB+y5i8EmnlAWyqlknLWQSsjDCpAZG1cwJA==
X-Received: by 2002:a17:90a:d0c4:: with SMTP id y4mr17148044pjw.116.1568570521680;
        Sun, 15 Sep 2019 11:02:01 -0700 (PDT)
Received: from [172.27.227.180] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id q20sm9217187pfl.79.2019.09.15.11.01.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 11:02:00 -0700 (PDT)
Subject: Re: [patch iproute2-next 1/2] devlink: introduce cmdline option to
 switch to a different namespace
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
References: <20190914064608.26799-1-jiri@resnulli.us>
 <20190914065757.27295-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7e0b36d6-4d83-d267-80b5-196aec83a18f@gmail.com>
Date:   Sun, 15 Sep 2019 12:01:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190914065757.27295-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/19 12:57 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 

Both of these patches have no commit logs. Please add - e.g., why -N
versus -n that other commands use.

> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
> v3->v4:
> - rebased on top of trap patches
> ---
>  devlink/devlink.c  | 12 ++++++++++--
>  man/man8/devlink.8 |  4 ++++
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 



