Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DADD13BB52
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 19:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388381AbfFJRsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 13:48:24 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36921 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388212AbfFJRsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 13:48:23 -0400
Received: by mail-pl1-f193.google.com with SMTP id bh12so3950521plb.4
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 10:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9LEFAut+zOY0k7cdu+hUslch3jniusDqbQv2tpm2P5Q=;
        b=bGWgxa/I+8bqqRawU6AS14qyZ0s3K8ja9uiu0HCSY6DHb2YR8A1wkhqmBjMyrCc9J4
         xNCB31y+kT7Xo9YwbA/XBWDplMSmluk8RDU7MpFjq6sJDXN5jZgemv2QuKFXn+oEA9i6
         G0YK06JavlzZYmQxruHlUsEC2AeViEnsPgv4xe4R32RczNLQwYwg/uK5h28BucyEtg9j
         mxvFS903ewbad8+sgjdSvY6+eKIzZYzdXhN9g8Jzq3cMvX5gmm1vAWAs1r9UK9gfOtNs
         FtpH4p3OaKlio99xCzl/StR9yJMYV0+XRA5ViGjLXixvUPLc1YAUXmjm79TAF7lNjvyE
         PgCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9LEFAut+zOY0k7cdu+hUslch3jniusDqbQv2tpm2P5Q=;
        b=NBQLcPDMeoUOiU7VJsyaTBdckbHriVVkOeT6hyumDqDBxRdycCKQVTY6k5D7ywFkor
         Vic7JCitL5fl7sgxfer5kU+7yV1hXveODQ+dROFo/NBt+3nlL9Zfbf+uZ8Np594q+ZX5
         YTVbZL+A4ut2P+W8ANxEdPSF3/hFw1kEphYM9BT7vOkR93lkUS3EtYfe6mWQ+iYHX2wC
         7AUQWxkrFRM2G5uHhfGplFeD1+NYqL9+y9NqmEQ9Pch7e1ChRanf2j+Apv0S+C8jZxs6
         3y3xOZEBYfl6xb9+6d4Su3WWoUzVuFMvnx8GFbX2BohoBmn8WuEyhrc3xby74yhBracz
         10Nw==
X-Gm-Message-State: APjAAAUb5MnfgYKmTUYc/p/tKUcA+3fAI3wiUMLIZw/727fgrSgP96YF
        mYul5qyU/UOEBPKzJKnoDcwf4Q==
X-Google-Smtp-Source: APXvYqz+2q8YdfiPfHVOCaE67Rl+5Zk0AyeQ2kE915b4lYd5+Oc5hqkAzmDNP07e87E5r4g7CDUXXA==
X-Received: by 2002:a17:902:22:: with SMTP id 31mr69344566pla.15.1560188903239;
        Mon, 10 Jun 2019 10:48:23 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 5sm11069104pfh.109.2019.06.10.10.48.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 10:48:23 -0700 (PDT)
Date:   Mon, 10 Jun 2019 10:48:21 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Mahesh Bandewar <maheshb@google.com>
Cc:     Mahesh Bandewar <mahesh@bandewar.net>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2] ip6tunnel: fix 'ip -6 {show|change} dev
 <name>' cmds
Message-ID: <20190610104821.0a7c6b8a@hermes.lan>
In-Reply-To: <20190606234426.208019-1-maheshb@google.com>
References: <20190606234426.208019-1-maheshb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Jun 2019 16:44:26 -0700
Mahesh Bandewar <maheshb@google.com> wrote:

> Inclusion of 'dev' is allowed by the syntax but not handled
> correctly by the command. It produces no output for show
> command and falsely successful for change command but does
> not make any changes.
> 
> can be verified with the following steps
>   # ip -6 tunnel add ip6tnl1 mode ip6gre local fd::1 remote fd::2 tos inherit ttl 127 encaplimit none
>   # ip -6 tunnel show ip6tnl1
>   <correct output>
>   # ip -6 tunnel show dev ip6tnl1
>   <no output but correct output after this change>
>   # ip -6 tunnel change dev ip6tnl1 local 2001:1234::1 remote 2001:1234::2 encaplimit none ttl 127 tos inherit allow-localremote
>   # echo $?
>   0
>   # ip -6 tunnel show ip6tnl1
>   <no changes applied, but changes are correctly applied after this change>
> 
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>

Applied, thanks.
