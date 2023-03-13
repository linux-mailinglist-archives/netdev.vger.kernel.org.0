Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252586B7B54
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 16:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbjCMO7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbjCMO7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:59:21 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE6136FC4
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 07:58:35 -0700 (PDT)
Received: from [192.168.0.10] ([176.126.68.120]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1N5max-1qcqyK1RZT-017EpX; Mon, 13 Mar 2023 15:52:23 +0100
Message-ID: <92a1e05a-f892-5c1b-842a-d55662b9d26a@kpanic.de>
Date:   Mon, 13 Mar 2023 15:52:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net] iavf: fix hang on reboot with ice
Content-Language: de-DE
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, patryk.piotrowski@intel.com,
        slawomirx.laba@intel.com
References: <20230310122653.1116051-1-sassmann@kpanic.de>
 <ZAtnqlHZ02EJn5xt@localhost.localdomain>
 <9f1e4087-239e-3a1a-dc35-59a4680e676b@kpanic.de>
 <ZA7pqdS04x0T7ExN@localhost.localdomain>
From:   Stefan Assmann <sassmann@kpanic.de>
In-Reply-To: <ZA7pqdS04x0T7ExN@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:cHoSFw/gCEtDp/feENelhn4dYudd9rtFneeleWLmt1gE/W/ZZ80
 PkXKEkgR2EVits1zGBQlIb523h49NTda1kKxbGblu/EuJX1q2UWuO5iQfRzL8o41VK5h6BG
 FOa5xwcYJd/hZyQNw4tDhYfxMOAnZNJj62OmvC75SIu/9QwDNFOu/Yh1AszSpwSLjNVkwci
 o4q7tg/8NR831DdW9k2lQ==
UI-OutboundReport: notjunk:1;M01:P0:nQ8hMNZEjUo=;c14ct7rGOdU1aNPwBKJ8Vy3pRiY
 r+g8nEeeWRMz4/NZjNWl3LZzUh2sdzIiWYdzwxM/J9rjjA9IPAEWWzliEvJunbq08kGnTpftm
 X82cZIhXIxPefDIUpINXtBra9SoeYW+UyLstDlwCm7A6UJNQy8Rcx3CDMpJ7xm4A63OFLTeia
 dB+tTyYaAnoEr+7eAivcR7cqx80I8WPQp4DrrVa51fnFY50PC2e8ZGya/qhaBAu9CR+OM2uJw
 UHLAu5I38KN6OVjgMQclXVF6CEvoLtxM+ouj1qQfJHppSdTcroy3tNKdkOqSW5Z6k5DHQ8oqo
 ++oIoMb73oNr0s9pteP0H1l7HeFuyI4wM7M7fUGS7rZ3wroa1hNM/iXsdvsdYcnum4tPpJLgp
 NRymyJitGuYSX+7txIMIuJmQR59YwwtiRKlnQLFQGArIEtrB8mBu+mETKKqxxFqReDNsbtMrK
 Ke8nmQ0sBfuDllB2HsSpYcwlz4F1Yi5k2rGgywHzrt/JlNSpsxphW9MUOKq5GUF9N6qs9j8wC
 zJdJp1vjNJTnPTIycgTa2b2SH+IpWbOiSgq5O79D+vYuCJhcGu4ZOaAzpUC6CP9fNnQXxLELr
 chvMBAqb4Wrym5/RVK1Wte578iNOM46NMbHux1l1zS+Umn8DTG2n7/73eRPGIVJPWI+73P42g
 kYkWDcHgKwzGDq3TnfZpCR+yB0rHPvTjCLBJcDq5FA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.03.23 10:15, Michal Kubiak wrote:
> On Mon, Mar 13, 2023 at 07:48:52AM +0100, Stefan Assmann wrote:
>>
>> Hi Michal,
>>
>> is it okay to add this change in a follow-up patch? I'd like to get this
>> patch merged quickly since we have a customer being blocked by this
>> issue.
>>
>> Thanks!
>>
>>   Stefan
> 
> 
> Hi Stefan,
> 
> I think it is OK.
> Moreover, I consulted that idea with Slawomir Laba - the author of that loop.
> It seems adding a timeout needs a further investigation. Slawomir claims
> that adding that timeout may cause some side effects in other corner cases,
> so for now let's leave your patch as it is.
> Thank you for fixing it!

Hi Michal, Slawomir,

I looked at this once more and noticed that iavf_remove() had the
following code removed in a8417330f8a5.
       /* When reboot/shutdown is in progress no need to do anything
        * as the adapter is already REMOVE state that was set during
        * iavf_shutdown() callback.
        */
       if (adapter->state == __IAVF_REMOVE)
               return;

So instead of breaking out of the while(1) loop, in iavf_remove(), it
might be better to simply return and avoid going through the whole of
iavf_remove(). That's more in line with the behaviour before
a8417330f8a5.
Otherwise pci_disable_device() might be called twice and give a warning,

  Stefan

> 
> Thanks,
> Michal
> 
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> 
