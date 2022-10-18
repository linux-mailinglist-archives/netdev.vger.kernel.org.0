Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE69C6029FB
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 13:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiJRLOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 07:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiJRLN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 07:13:56 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710CFB7F44
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 04:13:43 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id h203so11423160iof.1
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 04:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1sNQaxslGRn7j8mwW/A3EBiiklgGPtuls0wdm4aJVrA=;
        b=W+6yt1fFaD3+1XA3/UuZ+PfzTKo94QiOuA8zOOD1qlPjpmYVOizwm4vd9q96lKI7LQ
         N7MSAQCF1Zn/zzfxc6JXDlk8e4sfb5Y0r1N0SzofyYxkaWmk9TgKhZmuVLwZ0M9EE159
         zOFIuZe2ipIazEUgushgwZHlEIg44snt7EaYLuxc5WPDt2wf7QLTLkxks+eS1pNYrlYL
         saC2+HySOIiYT7w8F52XECfCsPPr/O+1zXpu7cbCjMinku1MKysOI1OlNobh0Hx5TjQm
         6BUrZEPqK5MhzoSj1xAAhpOBlXtZRl9oGUekv+7nNBMnnXxFMUQTfh8nTC0gVLtJWA8Q
         c0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1sNQaxslGRn7j8mwW/A3EBiiklgGPtuls0wdm4aJVrA=;
        b=OM1ull0/wsoLDkUahKANCptN1tAhyZ4wwLg8QiZVOFiU/qfWYM3iLvQUlm8VXVw0Ux
         4A7dibAtaM6cHCb+ubaRLgZDI/JJSvSiWul4p/s3ShpMmE20cRmcDdeJTPtEuRnvp/dm
         tcY3tRYTzKO6hEGbgLth1sibrZhbrroTq0f6bl856u12Zy201PPEmUV9jSJ/oQAHQ9Vb
         dYBrZJyFii1Qj9Z5JshEdAul1riLqdLE1zXINav7bruhAJ7au9Fmf1552CKtmuIaTlnw
         AC4ggPnhOpLLjpPWCXofujopfGPQJHPoWWfI0jKFvBZ7vy9E6uyqEhFOx+ujwf9E2hK7
         Xd2A==
X-Gm-Message-State: ACrzQf1piJZ8pzBrkU7Z5irf4LX616OP9JgVou6q6BT857/PwTY6A1hk
        4pjiTMwOH+2/2hF7emd67vv1wXReDiM90ze2f8bwUqxWsYfFyl2Qf1w=
X-Google-Smtp-Source: AMsMyM6HBcMbxCd0s0Pzi4EuMCpCgjyFMVqNDam0O70s55m06g0m3O3S8PUMudLUiYuyOf8sTVe+mYgQpWjSq7qBfDc=
X-Received: by 2002:a05:6638:4987:b0:363:c403:28ff with SMTP id
 cv7-20020a056638498700b00363c40328ffmr1419784jab.235.1666091622005; Tue, 18
 Oct 2022 04:13:42 -0700 (PDT)
MIME-Version: 1.0
References: <20221003095725.978129-1-m.chetan.kumar@linux.intel.com>
 <CAHNKnsT9EpOCd2Rj=5dQO5a2JrsHuyZQUG9apbrxHTehe37yug@mail.gmail.com>
 <192037d6-3b4d-d059-283b-3fa5094d5465@linux.intel.com> <CAHNKnsSvQNwjttQQPjKJ5aEtm6rfddrjKjd1TafcoyH1L51m-w@mail.gmail.com>
 <eb68e77a-518e-3b3d-4c63-2a06390cce43@linux.intel.com>
In-Reply-To: <eb68e77a-518e-3b3d-4c63-2a06390cce43@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 18 Oct 2022 15:13:40 +0400
Message-ID: <CAHNKnsSkXJZMqA2sw5wu3Z7H659ue0qFfS90kbBA-Nra2NLcBA@mail.gmail.com>
Subject: Re: [PATCH V3 net-next] net: wwan: t7xx: Add port for modem logging
To:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        Moises Veleta <moises.veleta@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 8:29 AM Kumar, M Chetan
<m.chetan.kumar@linux.intel.com> wrote:
> On 10/18/2022 5:29 AM, Sergey Ryazanov wrote:
>> On Mon, Oct 17, 2022 at 1:16 PM Kumar, M Chetan wrote:
>>> On 10/16/2022 9:35 PM, Sergey Ryazanov wrote:
>>>>>> On Mon, Oct 3, 2022 at 8:29 AM <m.chetan.kumar@linux.intel.com> wrote:
>>>>>>> The Modem Logging (MDL) port provides an interface to collect modem
>>>>>>> logs for debugging purposes. MDL is supported by the relay interface,
>>>>>>> and the mtk_t7xx port infrastructure. MDL allows user-space apps to
>>>>>>> control logging via mbim command and to collect logs via the relay
>>>>>>> interface, while port infrastructure facilitates communication between
>>>>>>> the driver and the modem.
>>>>>>
>>>>>> [skip]
>>>>>>
>>>>>>> diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
>>>>>>> index dc4133eb433a..702e7aa2ef31 100644
>>>>>>> --- a/drivers/net/wwan/t7xx/t7xx_port.h
>>>>>>> +++ b/drivers/net/wwan/t7xx/t7xx_port.h
>>>>>>> @@ -122,6 +122,11 @@ struct t7xx_port {
>>>>>>>           int                             rx_length_th;
>>>>>>>           bool                            chan_enable;
>>>>>>>           struct task_struct              *thread;
>>>>>>> +#ifdef CONFIG_WWAN_DEBUGFS
>>>>>>> +         void                            *relaych;
>>>>>>> +         struct dentry                   *debugfs_dir;
>>>>>>> +         struct dentry                   *debugfs_wwan_dir;
>>>>>>
>>>>>> Both of these debugfs directories are device-wide, why did you place
>>>>>> these pointers in the item port context?
>>>
>>> I guess it was kept inside port so that it could be accessed directly
>>> from port context.
>>>
>>> Thanks for pointing it out. I think we should move out the complete
>>> #ifdef CONFIG_WWAN_DEBUGFS block of port container.
>>
>> Moving out debugfs directory pointers sounds like a good idea.
>> Introduction of any new debugfs knob will be a much easier if these
>> pointers are available in some device-wide state container. But the
>> relaych pointer looks like a logging port specific element. Why should
>> it be moved out?
>
> t7xx_port is a common port container. keeping relaych pointer inside
> port container is like having relaych pointer for all port instance
> (AT/MBIM) though it is not required for others. So planning to move out.
>
> You suggest to keep it or move out ?

The t7xx_port structure already has a WWAN port specific field - wwan_port.

We can group such specific and otherwise useless fields into a union. Like this:

--- a/drivers/net/wwan/t7xx/t7xx_port.h
+++ b/drivers/net/wwan/t7xx/t7xx_port.h
@@ -99,7 +99,6 @@ struct t7xx_port_conf {
 struct t7xx_port {
        /* Members not initialized in definition */
        const struct t7xx_port_conf     *port_conf;
-       struct wwan_port                *wwan_port;
        struct t7xx_pci_dev             *t7xx_dev;
        struct device                   *dev;
        u16                             seq_nums[2];    /* TX/RX
sequence numbers */
@@ -122,6 +121,10 @@ struct t7xx_port {
        int                             rx_length_th;
        bool                            chan_enable;
        struct task_struct              *thread;
+       union { /* Port type specific data */
+               struct wwan_port        *wwan_port;
+               struct rchan            *relaych;
+       };
 };

Or even like this:

--- a/drivers/net/wwan/t7xx/t7xx_port.h
+++ b/drivers/net/wwan/t7xx/t7xx_port.h
@@ -99,7 +99,6 @@ struct t7xx_port_conf {
 struct t7xx_port {
        /* Members not initialized in definition */
        const struct t7xx_port_conf     *port_conf;
-       struct wwan_port                *wwan_port;
        struct t7xx_pci_dev             *t7xx_dev;
        struct device                   *dev;
        u16                             seq_nums[2];    /* TX/RX
sequence numbers */
@@ -122,6 +121,14 @@ struct t7xx_port {
        int                             rx_length_th;
        bool                            chan_enable;
        struct task_struct              *thread;
+       union { /* Port type specific data */
+               struct {
+                       struct wwan_port        *wwan_port;
+               } wwan;
+               struct {
+                       struct rchan            *relaych;
+               } log;
+       };
 };

Or, if we want more isolation, we can define per port type structures
and make the field in t7xx_port opaque:

@@ -99,7 +99,6 @@ struct t7xx_port_conf {
 struct t7xx_port {
        /* Members not initialized in definition */
        const struct t7xx_port_conf     *port_conf;
-       struct wwan_port                *wwan_port;
        struct t7xx_pci_dev             *t7xx_dev;
        struct device                   *dev;
        u16                             seq_nums[2];    /* TX/RX
sequence numbers */
@@ -122,8 +121,23 @@ struct t7xx_port {
        int                             rx_length_th;
        bool                            chan_enable;
        struct task_struct              *thread;
+       char                            priv[0x10];     /* Port type
private data */
 };

+#define t7xx_port_priv(__p)    ((void *)&((__p)->priv))
+
+struct t7xx_port_wwan {
+       struct wwan_port                *wwan_port;
+};
+
+BUILD_BUG_ON(sizeof(struct t7xx_port_wwan) > sizeof(port->priv));
+
+struct t7xx_port_log {
+       struct rchan                    *relaych;
+};
+
+BUILD_BUG_ON(sizeof(struct t7xx_port_log) > sizeof(port->priv));

I do not want to suggest any specific solution, it is always up to you
how to develop your code. I just wanted to point out the unexpected
pointers location and the possible difficulty of accessing the debugfs
directory pointer in the future.

-- 
Sergey
