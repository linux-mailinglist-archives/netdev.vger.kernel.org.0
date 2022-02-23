Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3E34C09F9
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 04:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237530AbiBWDJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 22:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiBWDJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 22:09:29 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AFD4D623
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 19:09:03 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id p8so14019434pfh.8
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 19:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T8hvzWHJX2wv2hbF8sfBZ7kL3wC7nPTxJ8uMv2KMD0Q=;
        b=cp3pz3XauUayBjMLKZsZ0hOjwUTeaUpvuNsgrbBzCPNeOBgCqtGv9CmTq9II1uO6ZR
         hweiE+6JlLrTPaOCLZxr/YgJ/OIoe2Tcma5Vmurig7a7HSz2Q/sJSPcGParIzrMnHEFb
         nVc650sQmsyCM3cis4iD4gRxeP/pVIHTZgL4PSr+l/21pYcV1XwG1OJsaStMsIvs95xi
         2b6RI/w33se/I6PIWkcO6+8MeAMvXesgDRVfwKMhxqAHnpjQ4l4AcxuZINdM2sj2EADm
         XiMlEt1fdKwLKD4x6LE1/ZogauDGTUWKMdHh5lN+ViKuEhaTYqAXqApAHm6IHUJffhrk
         jNSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T8hvzWHJX2wv2hbF8sfBZ7kL3wC7nPTxJ8uMv2KMD0Q=;
        b=f9w2ALFWsNI1s0mgvBFpyhW9yINMdWD75qjDAl3Nc+8Sf1etpaRK2gPyT7YFd6cAJp
         lkp4NpFLlFi9zC5Ta+w04Qc/Qm2ce88oWcU4ycZLhofS93i40HVNQcw6nnpzwF89+K7p
         Gg4yoQR2Wraki90L3XR4rhSjWefR5vgRGShX4x9CSN92Uju1wkv+Ah/rZnKa+waF6VRy
         zUguQL+GmHavco10DUdhPI9c/zlpIcjPQn5EHvQNUl7ORl4ec6nnuDihWsMusJbDR++A
         Fsn45gQ9WKdcZ1jKwS8gdISnVyohbwKyGnqd364t5QVQ7dREwzyIkH+RH9LWvMHQ0W+E
         fTLw==
X-Gm-Message-State: AOAM532hnu8iGMspYTOwBlZ4/m2fpq6oaZDbHmP/qdhKbt3eNO7zJfV8
        HkywC33AC8f2Pat2TMzwsQebQw==
X-Google-Smtp-Source: ABdhPJx5TnLcAA4LYZ/U6t5AmQeVu4NOHVepbx9KQ5exCO5gyAwo8fkUzTiFxCUdQdJqU3zBxJjtlw==
X-Received: by 2002:a05:6a00:244f:b0:4cc:a2ba:4cd8 with SMTP id d15-20020a056a00244f00b004cca2ba4cd8mr28145180pfj.74.1645585742854;
        Tue, 22 Feb 2022 19:09:02 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id m16sm18288197pfc.156.2022.02.22.19.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 19:09:02 -0800 (PST)
Date:   Tue, 22 Feb 2022 19:08:59 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Geliang Tang <geliang.tang@suse.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH iproute2-next v2 1/3] mptcp: add fullmesh check for
 adding address
Message-ID: <20220222190859.4b79cbf4@hermes.local>
In-Reply-To: <295a693ecc4ec1c3c241db0999d97d8718b7d992.1645584573.git.geliang.tang@suse.com>
References: <cover.1645584573.git.geliang.tang@suse.com>
        <295a693ecc4ec1c3c241db0999d97d8718b7d992.1645584573.git.geliang.tang@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022 10:59:47 +0800
Geliang Tang <geliang.tang@suse.com> wrote:

> +			if (adding &&
> +			    (flags & MPTCP_PM_ADDR_FLAG_SIGNAL) &&
> +			    (flags & MPTCP_PM_ADDR_FLAG_FULLMESH))
> +				invarg("invalid flags\n", *argv)

There is a duplicate newline here, the message already gets newline from invarg().
If possible could you give explanation to the user.

Looks like mptcp has this in lots of places, and would be helpful
to give better response.
