Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 579A04D9AED
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 13:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348171AbiCOMQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 08:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344714AbiCOMQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 08:16:31 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215D2488B2
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 05:15:18 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id p15so40825680ejc.7
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 05:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=Vi+2325S3UhNuSwEkzE7zxDYlg80Gl90oVsQ1baVx6k=;
        b=lXVeCHFZnVPl27HaQHK4dOGSxioAyOLmcaZ/jiS+FruLEekLCNYigdBkQBJ5q1ApYD
         SFM0ziU6uMyn/RupOG6NClEswmDnENZLmayFZ+eJBq0Uby5QXkzbEOdy6PhGnks4/xb3
         vyGDK2r5EE1+5tIMnnruypjXPtijUx9/clMN4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=Vi+2325S3UhNuSwEkzE7zxDYlg80Gl90oVsQ1baVx6k=;
        b=FH4b4zwNfFvrKMebjbSoIXDdguyglJ8T7ClbZQaE32iqqY5LwP5jhA5vY9BR5GSjvO
         Bh626RM58TPPTs3wUGQGBPU0g2TlW+iYY4EwgQVrC+ACqkFZbM2lBigeN1tD66EsO1gZ
         Of0IgpPG5s2R0SnV3Qy+bGnqJrS7CeUZBZ43SKMi0N7Sw8uezVDyRG3aVzWc69z6raEX
         tmcw75QAgNqswl1R0qgqABI3pPdD90eEWScd8fPuhu/yy3jExR3OTTbXadn84lsO1q02
         mjNRRNVwzctBDt5DQM8jGKxCC4IT6mtAIt4Y6hfoPCAiTx3GKMFLppSXMS00sOqFbX8p
         GvWw==
X-Gm-Message-State: AOAM531ZXrFmH7k9PPrBIvDE2lcWeF68eYMq0jVsPdQNHxQhUGhjV7xF
        GCgDSA7n8m/8mMmKSB6OD1CczA==
X-Google-Smtp-Source: ABdhPJwFooSX0DMCKphFL7uky55Q/OKWuvI2PKtqCcJCzp4TfqCEVQGpMc4BkqsFXywWBhD05MKwxQ==
X-Received: by 2002:a17:907:6da8:b0:6db:f0cf:af75 with SMTP id sb40-20020a1709076da800b006dbf0cfaf75mr3141069ejc.548.1647346516084;
        Tue, 15 Mar 2022 05:15:16 -0700 (PDT)
Received: from cloudflare.com ([2a01:110f:4809:d800::f9c])
        by smtp.gmail.com with ESMTPSA id k3-20020a05640212c300b0041605b2d9c1sm9104431edx.58.2022.03.15.05.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 05:15:15 -0700 (PDT)
References: <20220314124432.3050394-1-wangyufen@huawei.com>
 <87sfrky2bt.fsf@cloudflare.com>
 <ff9d0ecf-315b-00a3-8140-424714b204ff@huawei.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     wangyufen <wangyufen@huawei.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        lmb@cloudflare.com, davem@davemloft.net, kafai@fb.com,
        dsahern@kernel.org, kuba@kernel.org, songliubraving@fb.com,
        yhs@fb.com, kpsingh@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] bpf, sockmap: Manual deletion of sockmap
 elements in user mode is not allowed
Date:   Tue, 15 Mar 2022 13:12:08 +0100
In-reply-to: <ff9d0ecf-315b-00a3-8140-424714b204ff@huawei.com>
Message-ID: <87fsnjxvho.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 03:24 PM +08, wangyufen wrote:
> =E5=9C=A8 2022/3/14 23:30, Jakub Sitnicki =E5=86=99=E9=81=93:
>> On Mon, Mar 14, 2022 at 08:44 PM +08, Wang Yufen wrote:
>>> A tcp socket in a sockmap. If user invokes bpf_map_delete_elem to delete
>>> the sockmap element, the tcp socket will switch to use the TCP protocol
>>> stack to send and receive packets. The switching process may cause some
>>> issues, such as if some msgs exist in the ingress queue and are cleared
>>> by sk_psock_drop(), the packets are lost, and the tcp data is abnormal.
>>>
>>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>>> ---
>> Can you please tell us a bit more about the life-cycle of the socket in
>> your workload? Questions that come to mind:
>>
>> 1) What triggers the removal of the socket from sockmap in your case?
> We use sk_msg to redirect with sock hash, like this:
>
> =C2=A0skA=C2=A0=C2=A0 redirect=C2=A0=C2=A0=C2=A0 skB
> =C2=A0Tx <-----------> skB,Rx
>
> And construct a scenario where the packet sending speed is high, the
> packet receiving speed is slow, so the packets are stacked in the ingress
> queue on the receiving side. In this case, if run bpf_map_delete_elem() to
> delete the sockmap entry, will trigger the following procedure:
>
> sock_hash_delete_elem()
> =C2=A0 sock_map_unref()
> =C2=A0=C2=A0=C2=A0 sk_psock_put()
> =C2=A0=C2=A0=C2=A0 =C2=A0 sk_psock_drop()
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 sk_psock_stop()
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 __sk_psock_zap_ingress()
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 __sk_psock_purge=
_ingress_msg()
>
>> 2) Would it still be a problem if removal from sockmap did not cause any
>> packets to get dropped?
> Yes, it still be a problem. If removal from sockmap=C2=A0 did not cause a=
ny
> packets to get dropped, packet receiving process switches to use TCP
> protocol stack. The packets in the psock ingress queue cannot be received
>
> by the user.

Thanks for the context. So, if I understand correctly, you want to avoid
breaking the network pipe by updating the sockmap from user-space.

This sounds awfully similar to BPF_MAP_FREEZE. Have you considered that?
