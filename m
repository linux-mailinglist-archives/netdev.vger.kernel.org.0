Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2223DDE36
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 19:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhHBRJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 13:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhHBRJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 13:09:38 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A111C061760
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 10:09:29 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id h186-20020a37b7c30000b02903b914d9e335so13419597qkf.17
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 10:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=lKCtubTbrOBtT39hLra/H/0dtaesRzNhr4fxHcuboVQ=;
        b=Kj7so7AVjic1esHW00+yaTWx1om0OY/HjjK5+rs+EKUP2wqrmTKmtSsGYnwQhRDUx4
         +lbmZxH7QUHQxf0jXHSkMJMXK45qJaJXrcv6M1KepeNVION1G86DHizWeeIYWsnuILfp
         SwxMBC/jc0VFCEfTr5hHdsVMfmKnOvGB0tH+Be0x3FbRcaLC0Jsm9K27MEBEd5qhHP07
         kkwB1iDbE3k+IEdUOpSEV4ikAzxRIKCyZXUORmMFqVLNFPTQzX64z0HdZW828qu3B2eG
         dUKGwC2sD6CRPtx5ADRdVb/g7UBusLaD5bhKBBDVH0Gjs3PhizxTer8DxnIPQnkbMHNT
         vPVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=lKCtubTbrOBtT39hLra/H/0dtaesRzNhr4fxHcuboVQ=;
        b=hNniKAKgYBFKET6mrZNgAu8zspNG7I0UfanQaogNYawgL0YBehngYbqPLu/Tlk36nj
         yd3Cq/vjtbeCN5GrqJO34/1lRBv5rP8LmuSiSVYMoE25T1bWy+0pYJ6u/1zT+jEva1BE
         9KP90BYQMG+qpGokdzScOcxRsGybwV1au10oL4W+FxGRbX9648+7ywjIq3I5ULwvgWWu
         OiWdMyWHlcCS6xHpqXqVONNYjFoLhxHtTTGtoxPQAm6QVzfSXHacvQm50yvFWo8ZM/e+
         LRj8tQu1tEIxEoS7vGHbjNmiVUF+setN/A99hlxjbyF1tGLm/0mHGifnWGJKRsUxvQsY
         2Avw==
X-Gm-Message-State: AOAM531MvmEfxh5K0+lKdo0Jvt/+jHl2mGwfNcjGS9m2GNnqHhh6AsDG
        /dVbqYm+Ocl9f/RHO1HCp4UvzfScHEKhdSphn2NI+A==
X-Google-Smtp-Source: ABdhPJxi+9VmXga6op0MBdHSq6XgSWbJP9QEWxquXxNzdo+g46f0B9P+zmYlyEpmybmi0J+T+YnCUUyl+gmUUpRVQUJYzw==
X-Received: from mustash.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:337b])
 (user=richardsonnick job=sendgmr) by 2002:a05:6214:e88:: with SMTP id
 hf8mr5132211qvb.40.1627924168512; Mon, 02 Aug 2021 10:09:28 -0700 (PDT)
Date:   Mon,  2 Aug 2021 17:09:10 +0000
In-Reply-To: <20210802071126.3b311638@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-Id: <20210802170910.2190218-1-richardsonnick@google.com>
Mime-Version: 1.0
References: <20210802071126.3b311638@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: Re: [PATCH net-next] pktgen: Fix invalid clone_skb override
From:   Nicholas Richardson <richardsonnick@google.com>
To:     kuba@kernel.org
Cc:     nrrichar@ncsu.edu, arunkaly@google.com, netdev@vger.kernel.org,
        Nicholas Richardson <richardsonnick@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a user passes a negative value for clone_skb, the num_args() function =
stops parsing at the first nonnumeric value. This makes it impossible for c=
lone_skb to be set to a negative value. For example: "clone_skb -200" would=
 stop parsing at the first char ('-') and return zero for the new clone_skb=
 value.

So to answer your question: No clone_skb cannot be negative.

Apologies for the email format errors and thanks for the quick reply!
